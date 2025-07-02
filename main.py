import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime, date
import io
import json
import os

st.set_page_config(
    page_title="NPO法人ながいく - 助成金管理システム",
    page_icon="💰",
    layout="wide",
    initial_sidebar_state="expanded"
)

def save_grants_to_csv(grants: list, filename: str = "grants_data.csv") -> None:
    """助成金データをCSVファイルに保存する"""
    if not grants:
        return
    
    # 助成金データをフラット化
    grants_data = []
    for grant in grants:
        # 予算項目を文字列として結合（ID付き）
        budget_items_str = "; ".join([
            f"{item.get('id', 'NO_ID')}:{item['name']}:¥{item['budget']:,}" 
            for item in grant.get('budget_items', [])
        ])
        
        grants_data.append({
            'id': grant['id'],
            'name': grant['name'],
            'source': grant['source'],
            'total_budget': grant['total_budget'],
            'start_date': grant['start_date'],
            'end_date': grant['end_date'],
            'description': grant['description'],
            'budget_items': budget_items_str,
            'created_at': grant['created_at']
        })
    
    df = pd.DataFrame(grants_data)
    # UTF-8 with BOMで保存（Windows環境での文字化けを防ぐ）
    with open(filename, 'w', encoding='utf-8-sig', newline='') as f:
        df.to_csv(f, index=False)
    st.success(f"✅ 助成金データを {filename} に保存しました（UTF-8 BOM形式）")

def load_grants_from_csv(filename: str = "grants_data.csv") -> list:
    """CSVファイルから助成金データを読み込む"""
    if not os.path.exists(filename):
        return []
    
    try:
        # エンコーディングを自動判定して読み込み
        df = None
        encodings = ['shift_jis', 'utf-8-sig', 'utf-8', 'cp932']
        
        for encoding in encodings:
            try:
                df = pd.read_csv(filename, encoding=encoding)
                break
            except (UnicodeDecodeError, UnicodeError):
                continue
        
        if df is None:
            st.error("❌ ファイルの文字エンコーディングを判定できませんでした")
            return []
        
        grants = []
        
        for _, row in df.iterrows():
            # 予算項目をパース
            budget_items = []
            budget_items_value = row['budget_items']
            if budget_items_value is not None and str(budget_items_value).strip() != 'nan':
                budget_items_str = str(budget_items_value).strip()
                if budget_items_str:
                    item_index = 1
                    for item_str in budget_items_str.split('; '):
                        parts = item_str.split(':')
                        if len(parts) >= 3:
                            # 新形式: ID:名前:¥金額
                            item_id, name, budget_str = parts[0], parts[1], parts[2]
                            budget = int(budget_str.replace('¥', '').replace(',', ''))
                            budget_items.append({
                                "id": item_id,
                                "name": name, 
                                "budget": budget
                            })
                        elif len(parts) == 2:
                            # 旧形式: 名前:¥金額
                            name, budget_str = parts[0], parts[1]
                            budget = int(budget_str.replace('¥', '').replace(',', ''))
                            # 予算項目IDを自動生成
                            item_id = f"GRANT{int(row['id'])}_ITEM{item_index}"
                            budget_items.append({
                                "id": item_id,
                                "name": name, 
                                "budget": budget
                            })
                        item_index += 1
            
            description_value = row['description']
            description = str(description_value) if description_value is not None and str(description_value).strip() != 'nan' else ''
            
            grant = {
                'id': int(row['id']),
                'name': row['name'],
                'source': row['source'],
                'total_budget': int(row['total_budget']),
                'start_date': row['start_date'],
                'end_date': row['end_date'],
                'description': description,
                'budget_items': budget_items,
                'created_at': row['created_at']
            }
            grants.append(grant)
        
        return grants
    except Exception as e:
        st.error(f"❌ ファイル読み込みエラー: {str(e)}")
        return []

def save_allocations_to_csv(allocations: dict, filename: str = "allocations_data.csv") -> None:
    """割り当てデータをCSVファイルに保存する（拡張版：部分金額割り当て対応）"""
    if not allocations:
        return
    
    allocation_data = []
    for trans_id, allocation_info in allocations.items():
        if isinstance(allocation_info, dict):
            # 新形式：{grant_name: str, budget_item_id: str, amount: float, transaction_amount: float}
            allocation_data.append({
                "取引ID": trans_id,
                "割り当て助成金": allocation_info.get('grant_name', ''),
                "予算項目ID": allocation_info.get('budget_item_id', ''),
                "割り当て金額": allocation_info.get('amount', 0),
                "取引金額": allocation_info.get('transaction_amount', 0)
            })
        else:
            # 旧形式：互換性のため
            allocation_data.append({
                "取引ID": trans_id,
                "割り当て助成金": allocation_info,
                "予算項目ID": '',
                "割り当て金額": 0,
                "取引金額": 0
            })
    
    df = pd.DataFrame(allocation_data)
    # UTF-8 with BOMで保存（Windows環境での文字化けを防ぐ）
    with open(filename, 'w', encoding='utf-8-sig', newline='') as f:
        df.to_csv(f, index=False)
    st.success(f"✅ 割り当てデータを {filename} に保存しました（UTF-8 BOM形式）")

def save_transactions_to_csv(transactions: pd.DataFrame, filename: str = "transactions_data.csv") -> None:
    """取引データをCSVファイルに保存する"""
    if transactions.empty:
        return
    
    try:
        # UTF-8 with BOMで保存（Windows環境での文字化けを防ぐ）
        with open(filename, 'w', encoding='utf-8-sig', newline='') as f:
            transactions.to_csv(f, index=False)
        st.success(f"✅ 取引データを {filename} に保存しました（UTF-8 BOM形式）")
    except Exception as e:
        st.error(f"❌ 取引データの保存エラー: {str(e)}")

def load_transactions_from_csv(filename: str = "transactions_data.csv") -> pd.DataFrame:
    """CSVファイルから取引データを読み込む"""
    if not os.path.exists(filename):
        return pd.DataFrame()
    
    try:
        # エンコーディングを自動判定して読み込み
        df = None
        encodings = ['shift_jis', 'utf-8-sig', 'utf-8', 'cp932']
        
        for encoding in encodings:
            try:
                df = pd.read_csv(filename, encoding=encoding)
                break
            except (UnicodeDecodeError, UnicodeError):
                continue
        
        if df is None:
            st.error("❌ 取引ファイルの文字エンコーディングを判定できませんでした")
            return pd.DataFrame()
        
        return df
    except Exception as e:
        st.error(f"❌ 取引データ読み込みエラー: {str(e)}")
        return pd.DataFrame()

def load_allocations_from_csv(filename: str = "allocations_data.csv") -> dict:
    """CSVファイルから割り当てデータを読み込む（拡張版：部分金額割り当て対応）"""
    if not os.path.exists(filename):
        return {}
    
    try:
        # エンコーディングを自動判定して読み込み
        df = None
        encodings = ['shift_jis', 'utf-8-sig', 'utf-8', 'cp932']
        
        for encoding in encodings:
            try:
                df = pd.read_csv(filename, encoding=encoding)
                break
            except (UnicodeDecodeError, UnicodeError):
                continue
        
        if df is None:
            st.error("❌ 割り当てファイルの文字エンコーディングを判定できませんでした")
            return {}
        
        allocations = {}
        
        for _, row in df.iterrows():
            trans_id = str(row['取引ID'])  # 文字列として保存
            
            # 新形式データの確認
            if '予算項目ID' in row and '割り当て金額' in row and '取引金額' in row:
                try:
                    grant_name = str(row['割り当て助成金']) if str(row['割り当て助成金']) != 'nan' else ''
                    budget_item_id = str(row['予算項目ID']) if str(row['予算項目ID']) != 'nan' else ''
                    amount = float(row['割り当て金額']) if str(row['割り当て金額']) != 'nan' else 0.0
                    transaction_amount = float(row['取引金額']) if str(row['取引金額']) != 'nan' else 0.0
                except (ValueError, TypeError):
                    grant_name = ''
                    budget_item_id = ''
                    amount = 0.0
                    transaction_amount = 0.0
                
                allocations[trans_id] = {
                    'grant_name': grant_name,
                    'budget_item_id': budget_item_id,
                    'amount': amount,
                    'transaction_amount': transaction_amount
                }
            else:
                # 旧形式：互換性のため
                if '割り当て助成金' in row:
                    grant_name = row['割り当て助成金']
                elif '割り当て先' in row:
                    grant_name = row['割り当て先']
                else:
                    grant_name = str(row.iloc[1])
                
                allocations[trans_id] = grant_name
        
        return allocations
    except Exception as e:
        st.error(f"❌ 割り当てファイル読み込みエラー: {str(e)}")
        return {}

def initialize_session_state():
    if 'transactions' not in st.session_state:
        # 保存済みの取引データがあれば自動読み込み
        saved_transactions = load_transactions_from_csv()
        st.session_state.transactions = saved_transactions
    if 'grants' not in st.session_state:
        # 起動時に自動読み込み
        st.session_state.grants = load_grants_from_csv()
    if 'allocations' not in st.session_state:
        # 起動時に自動読み込み
        st.session_state.allocations = load_allocations_from_csv()

def main():
    # セッション状態の初期化（自動読み込み）
    initialize_session_state()
    
    # メインシステム
    st.title("💰 NPO法人ながいく - 助成金管理システム")
    st.markdown("---")
    
    # サイドバーでメニュー選択（常時表示）
    st.sidebar.title("📋 メニュー")
    
    # セッション状態でメニュー選択を管理
    if 'current_menu' not in st.session_state:
        st.session_state.current_menu = "📊 ダッシュボード"
    
    # メニューボタンを常時表示
    if st.sidebar.button("📊 ダッシュボード", use_container_width=True):
        st.session_state.current_menu = "📊 ダッシュボード"
    
    if st.sidebar.button("📂 freee データアップロード", use_container_width=True):
        st.session_state.current_menu = "📂 freee データアップロード"
    
    if st.sidebar.button("💰 助成金予算管理", use_container_width=True):
        st.session_state.current_menu = "💰 助成金予算管理"
    
    if st.sidebar.button("🔗 取引割り当て", use_container_width=True):
        st.session_state.current_menu = "🔗 取引割り当て"
    
    if st.sidebar.button("🎯 一括取引割り当て", use_container_width=True):
        st.session_state.current_menu = "🎯 一括取引割り当て"

    
    if st.sidebar.button("💾 データダウンロード", use_container_width=True):
        st.session_state.current_menu = "💾 データダウンロード"
    
    # 選択されたメニューに応じて表示
    menu = st.session_state.current_menu
    
    if menu == "📊 ダッシュボード":
        show_dashboard()
    elif menu == "📂 freee データアップロード":
        show_upload_page()
    elif menu == "💰 助成金予算管理":
        show_grant_management()
    elif menu == "🔗 取引割り当て":
        show_allocation_page()
    elif menu == "🎯 一括取引割り当て":
        show_bulk_allocation_page()
    elif menu == "💾 データダウンロード":
        show_data_download_page()

def show_dashboard():
    st.header("📊 ダッシュボード")
    
    # 基本統計の表示
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        st.metric("登録済み助成金数", len(st.session_state.grants))
    
    with col2:
        total_budget = sum(grant.get('total_budget', 0) for grant in st.session_state.grants)
        st.metric("総予算額", f"¥{total_budget:,}")
    
    with col3:
        st.metric("取引データ件数", len(st.session_state.transactions))
    
    with col4:
        allocated_count = len(st.session_state.allocations)
        st.metric("割り当て済み取引", allocated_count)
    
    st.markdown("---")
    
    if not st.session_state.transactions.empty:
        st.subheader("最近の取引")
        recent_transactions = st.session_state.transactions.head(10)
        
        # 金額列があれば右揃えで表示
        if '借方金額' in recent_transactions.columns:
            st.dataframe(
                recent_transactions, 
                use_container_width=True,
                column_config={
                    "借方金額": st.column_config.NumberColumn("借方金額"),
                }
            )
        else:
            st.dataframe(recent_transactions, use_container_width=True)
    else:
        st.info("取引データをアップロードしてください。")

def show_upload_page():
    st.header("📂 freee データアップロード")
    
    st.markdown("""
    ### 📋 アップロード手順
    1. freeeから取引データをCSV形式でエクスポート
    2. 下記のファイルアップローダーでCSVファイルを選択
    3. データプレビューを確認後、インポート実行
    """)
    
    uploaded_file = st.file_uploader(
        "freee CSVファイルをアップロード",
        type=['csv'],
        help="freeeからエクスポートしたCSVファイルを選択してください"
    )
    
    if uploaded_file is not None:
        try:
            # CSVファイルの読み込み（エンコーディングを自動判定）
            df = None
            encodings = ['shift_jis', 'utf-8-sig', 'utf-8', 'cp932']
            
            for encoding in encodings:
                try:
                    uploaded_file.seek(0)  # ファイルポインタをリセット
                    df = pd.read_csv(uploaded_file, encoding=encoding)
                    break
                except (UnicodeDecodeError, UnicodeError):
                    continue
            
            if df is None:
                st.error("❌ ファイルの文字エンコーディングを判定できませんでした。UTF-8またはShift_JISで保存されたCSVファイルをアップロードしてください。")
                return
            
            st.success("✅ ファイルが正常に読み込まれました")
            
            # データプレビュー
            st.subheader("📋 データプレビュー")
            st.dataframe(df.head(10), use_container_width=True)
            
            # データ情報
            col1, col2 = st.columns(2)
            with col1:
                st.info(f"📊 データ件数: {len(df)}件")
            with col2:
                st.info(f"📋 列数: {len(df.columns)}列")
            
            # 既存データチェック
            has_existing_data = not st.session_state.transactions.empty
            
            # インポートボタン
            if has_existing_data:
                st.warning("⚠️ 既存の取引データが存在します。インポートすると上書きされます。")
                col1, col2 = st.columns(2)
                
                with col1:
                    if st.button("🔄 上書きインポート", type="primary"):
                        st.session_state.transactions = df
                        # 取引データを自動保存
                        save_transactions_to_csv(df)
                        st.success("🎉 データが正常にインポート・保存されました！")
                        st.rerun()
                
                with col2:
                    if st.button("➕ 追加インポート"):
                        # 既存データと新データを結合（重複除去）
                        combined_df = pd.concat([st.session_state.transactions, df], ignore_index=True)
                        combined_df = combined_df.drop_duplicates()
                        st.session_state.transactions = combined_df
                        # 取引データを自動保存
                        save_transactions_to_csv(combined_df)
                        st.success("🎉 データが正常に追加・保存されました！")
                        st.rerun()
            else:
                if st.button("🔄 データをインポート", type="primary"):
                    st.session_state.transactions = df
                    # 取引データを自動保存
                    save_transactions_to_csv(df)
                    st.success("🎉 データが正常にインポート・保存されました！")
                    st.rerun()
                
        except Exception as e:
            st.error(f"❌ ファイル読み込みエラー: {str(e)}")

def show_grant_management():
    st.header("💰 助成金予算管理")
    
    st.markdown("---")
    
    # 新規助成金登録
    with st.expander("🆕 新規助成金登録", expanded=False):
        with st.form("new_grant_form"):
            col1, col2 = st.columns(2)
            
            with col1:
                grant_name = st.text_input("助成金名称")
                grant_source = st.text_input("助成元")
                total_budget = st.number_input("総予算額", min_value=0, step=1000)
            
            with col2:
                start_date = st.date_input("開始日")
                end_date = st.date_input("終了日")
                description = st.text_area("概要・備考")
            
            # 予算項目設定
            st.subheader("📊 予算項目設定")
            budget_items = []
            
            num_items = st.number_input("予算項目数", min_value=1, max_value=10, value=3)
            
            for i in range(int(num_items)):
                col1, col2 = st.columns(2)
                with col1:
                    item_name = st.text_input(f"項目名 {i+1}", key=f"item_name_{i}")
                with col2:
                    item_budget = st.number_input(f"予算額 {i+1}", min_value=0, step=1000, key=f"item_budget_{i}")
                
                if item_name and item_budget > 0:
                    # 予算項目IDを生成（助成金ID_項目インデックス）
                    item_id = f"GRANT{len(st.session_state.grants) + 1}_ITEM{i+1}"
                    budget_items.append({
                        "id": item_id,
                        "name": item_name, 
                        "budget": item_budget
                    })
            
            submitted = st.form_submit_button("💾 助成金を登録")
            
            if submitted and grant_name and total_budget > 0:
                new_grant = {
                    "id": len(st.session_state.grants) + 1,
                    "name": grant_name,
                    "source": grant_source,
                    "total_budget": total_budget,
                    "start_date": start_date.isoformat(),
                    "end_date": end_date.isoformat(),
                    "description": description,
                    "budget_items": budget_items,
                    "created_at": datetime.now().isoformat()
                }
                
                st.session_state.grants.append(new_grant)
                # 自動保存
                save_grants_to_csv(st.session_state.grants)
                st.success("🎉 助成金が正常に登録されました！")
                st.rerun()
    
    # 既存助成金一覧
    st.subheader("📋 登録済み助成金一覧")
    
    if st.session_state.grants:
        for grant in st.session_state.grants:
            with st.expander(f"💰 {grant['name']} ({grant['source']})"):
                col1, col2, col3 = st.columns(3)
                
                with col1:
                    st.write(f"**総予算額:** ¥{grant['total_budget']:,}")
                    st.write(f"**期間:** {grant['start_date']} ～ {grant['end_date']}")
                
                with col2:
                    st.write(f"**助成元:** {grant['source']}")
                    st.write(f"**登録日:** {grant['created_at'][:10]}")
                
                with col3:
                    if st.button(f"🗑️ 削除", key=f"delete_{grant['id']}"):
                        st.session_state.grants = [g for g in st.session_state.grants if g['id'] != grant['id']]
                        # 自動保存
                        save_grants_to_csv(st.session_state.grants)
                        st.success("助成金が削除されました")
                        st.rerun()
                
                if grant['budget_items']:
                    st.write("**予算項目:**")
                    # 予算額をカンマ区切りでフォーマット
                    budget_items_display = []
                    for item in grant['budget_items']:
                        budget_items_display.append({
                            "予算項目ID": item.get('id', '未設定'),
                            "項目名": item['name'],
                            "予算額": int(item['budget'])
                        })
                    items_df = pd.DataFrame(budget_items_display)
                    st.dataframe(
                        items_df, 
                        use_container_width=True,
                        column_config={
                            "予算額": st.column_config.NumberColumn("予算額"),
                        }
                    )
                
                if grant['description']:
                    st.write(f"**概要:** {grant['description']}")
    else:
        st.info("まだ助成金が登録されていません。上記のフォームから新規登録してください。")

def show_allocation_page():
    st.header("🔗 取引の助成金割り当て")
    
    if st.session_state.transactions.empty:
        st.warning("取引データがありません。まずfreeeデータをアップロードしてください。")
        return
    
    if not st.session_state.grants:
        st.warning("助成金が登録されていません。まず助成金を登録してください。")
        return
    
    st.markdown("---")
    
    # フィルター・並べ替え機能
    st.subheader("🔍 フィルター・並べ替え設定")
    
    # 初期データ準備（【事】【管】フィルタリング）
    transactions_filtered = st.session_state.transactions.copy()
    
    if not transactions_filtered.empty:
        # 【事】【管】で始まる借方勘定科目のみフィルタリング
        if '借方勘定科目' in transactions_filtered.columns:
            mask = transactions_filtered['借方勘定科目'].astype(str).str.startswith(('【事】', '【管】'))
            transactions_filtered = transactions_filtered[mask]
            
            if transactions_filtered.empty:
                st.warning("【事】【管】で始まる取引データがありません。")
                return
        else:
            st.error("借方勘定科目列が見つかりません。正しいfreeeデータをアップロードしてください。")
            return
    else:
        st.error("取引データがありません")
        return
    
    # フィルター設定
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        # 取引日範囲フィルター
        if '取引日' in transactions_filtered.columns:
            try:
                transactions_filtered['取引日'] = pd.to_datetime(transactions_filtered['取引日'], errors='coerce')
                min_date = transactions_filtered['取引日'].min().date()
                max_date = transactions_filtered['取引日'].max().date()
                
                date_range = st.date_input(
                    "取引日範囲",
                    value=[min_date, max_date],
                    min_value=min_date,
                    max_value=max_date,
                    key="date_filter"
                )
                
                if len(date_range) == 2:
                    start_date, end_date = date_range
                    mask = (transactions_filtered['取引日'] >= pd.Timestamp(start_date)) & \
                           (transactions_filtered['取引日'] <= pd.Timestamp(end_date))
                    transactions_filtered = transactions_filtered[mask]
            except:
                st.warning("取引日の処理でエラーが発生しました")
    
    with col2:
        # 借方部門フィルター
        if '借方部門' in transactions_filtered.columns:
            departments = transactions_filtered['借方部門'].dropna().unique().tolist()
            departments.sort()
            selected_departments = st.multiselect(
                "借方部門",
                options=departments,
                default=departments,
                key="dept_filter"
            )
            if selected_departments:
                transactions_filtered = transactions_filtered[
                    transactions_filtered['借方部門'].isin(selected_departments)
                ]
    
    with col3:
        # 借方勘定科目フィルター
        if '借方勘定科目' in transactions_filtered.columns:
            accounts = transactions_filtered['借方勘定科目'].dropna().unique().tolist()
            accounts.sort()
            selected_accounts = st.multiselect(
                "借方勘定科目",
                options=accounts,
                default=accounts,
                key="account_filter"
            )
            if selected_accounts:
                transactions_filtered = transactions_filtered[
                    transactions_filtered['借方勘定科目'].isin(selected_accounts)
                ]
    
    with col4:
        # 金額範囲フィルター
        if '借方金額' in transactions_filtered.columns:
            try:
                # 数値に変換して有効な値のみ取得
                numeric_amounts = []
                for val in transactions_filtered['借方金額']:
                    try:
                        numeric_val = float(val)
                        if pd.notna(numeric_val):
                            numeric_amounts.append(numeric_val)
                    except (ValueError, TypeError):
                        continue
                
                if numeric_amounts:
                    min_amount = int(min(numeric_amounts))
                    max_amount = int(max(numeric_amounts))
                    
                    amount_range = st.slider(
                        "借方金額範囲",
                        min_value=min_amount,
                        max_value=max_amount,
                        value=[min_amount, max_amount],
                        key="amount_filter"
                    )
                    
                    # フィルタリング実行
                    def filter_by_amount(row):
                        try:
                            amount = float(row['借方金額'])
                            return amount_range[0] <= amount <= amount_range[1]
                        except (ValueError, TypeError):
                            return False
                    
                    amount_mask = transactions_filtered.apply(filter_by_amount, axis=1)
                    transactions_filtered = transactions_filtered[amount_mask]
            except Exception as e:
                st.warning(f"金額フィルターの処理でエラーが発生しました: {str(e)}")
    
    # 並べ替え設定
    st.markdown("**📊 並べ替え設定**")
    col5, col6, col7 = st.columns(3)
    
    available_columns = ['取引日', '借方部門', '借方勘定科目', '借方金額', '借方取引先名', '借方備考', '借方メモ']
    available_columns = [col for col in available_columns if col in transactions_filtered.columns]
    
    with col5:
        sort_column1 = st.selectbox("第1並べ替え基準", options=available_columns, index=0 if available_columns else None, key="sort1")
        sort_order1 = st.selectbox("第1並べ替え順序", options=["昇順", "降順"], key="order1")
    
    with col6:
        sort_column2 = st.selectbox("第2並べ替え基準", options=["なし"] + available_columns, index=0, key="sort2")
        sort_order2 = st.selectbox("第2並べ替え順序", options=["昇順", "降順"], key="order2")
    
    with col7:
        sort_column3 = st.selectbox("第3並べ替え基準", options=["なし"] + available_columns, index=0, key="sort3")
        sort_order3 = st.selectbox("第3並べ替え順序", options=["昇順", "降順"], key="order3")
    
    # 並べ替え実行
    sort_columns = []
    sort_orders = []
    
    if sort_column1:
        sort_columns.append(sort_column1)
        sort_orders.append(sort_order1 == "昇順")
    
    if sort_column2 and sort_column2 != "なし":
        sort_columns.append(sort_column2)
        sort_orders.append(sort_order2 == "昇順")
    
    if sort_column3 and sort_column3 != "なし":
        sort_columns.append(sort_column3)
        sort_orders.append(sort_order3 == "昇順")
    
    if sort_columns:
        try:
            # 金額列の場合は数値として並べ替え
            for i, col in enumerate(sort_columns):
                if col == '借方金額':
                    transactions_filtered[col] = pd.to_numeric(transactions_filtered[col], errors='coerce')
                elif col == '取引日':
                    transactions_filtered[col] = pd.to_datetime(transactions_filtered[col], errors='coerce')
            
            transactions_filtered = transactions_filtered.sort_values(by=sort_columns, ascending=sort_orders)
        except:
            st.warning("並べ替えの処理でエラーが発生しました")
    
    st.markdown("---")
    
    st.subheader("📝 簡単な割り当て（表から直接編集）")
    st.info("💡 予算項目を選択すると、取引金額の100%が自動的に割り当てられます")
    st.info(f"📊 表示件数: {len(transactions_filtered)}件")
    
    # 予算項目選択肢を準備
    budget_options = ["未割り当て"]
    budget_item_map = {}
    
    for grant in st.session_state.grants:
        if grant.get('budget_items'):
            for item in grant['budget_items']:
                option_text = f"{grant['name']} - {item['name']} (¥{item['budget']:,})"
                budget_options.append(option_text)
                budget_item_map[option_text] = {
                    'grant_name': f"{grant['name']} ({grant['source']})",
                    'item_id': item.get('id', f"GRANT{grant['id']}_{item['name']}")
                }
    
    # フィルター済みデータを使用して編集可能な表形式で表示
    if not transactions_filtered.empty:
        edited_data = []
        transaction_ids = []
        
        for idx, row in transactions_filtered.iterrows():
            trans_id = f"{row['仕訳番号']}_{row['仕訳行番号']}"
            transaction_ids.append(trans_id)
            
            # 現在の割り当て状況を取得
            current_alloc = st.session_state.allocations.get(trans_id, {})
            current_selection = "未割り当て"
            
            if isinstance(current_alloc, dict) and current_alloc.get('budget_item_id'):
                # 予算項目IDから選択肢テキストを逆引き
                for option_text, info in budget_item_map.items():
                    if info['item_id'] == current_alloc['budget_item_id']:
                        current_selection = option_text
                        break
            
            # 取引金額をフォーマット
            trans_amount = 0
            if '借方金額' in row:
                try:
                    trans_amount = float(row['借方金額'])
                    formatted_amount = f"¥{trans_amount:,.0f}"
                except (ValueError, TypeError):
                    formatted_amount = str(row.get('借方金額', ''))
            else:
                formatted_amount = ""
            
            # 取引日の日付のみ表示（時間部分を除去）
            transaction_date = ''
            if pd.notna(row.get('取引日', '')):
                try:
                    # datetimeオブジェクトに変換して日付のみ取得
                    date_obj = pd.to_datetime(row['取引日'])
                    transaction_date = date_obj.strftime('%Y-%m-%d')
                except:
                    transaction_date = str(row.get('取引日', ''))
            
            # データ行を構築（すべての必要項目を含む）
            row_data = {
                '予算項目': current_selection,
                '取引日': transaction_date,
                '借方部門': str(row.get('借方部門', '')) if pd.notna(row.get('借方部門', '')) else '',
                '借方勘定科目': str(row.get('借方勘定科目', '')) if pd.notna(row.get('借方勘定科目', '')) else '',
                '借方金額': int(trans_amount) if trans_amount > 0 else 0,
                '借方取引先名': str(row.get('借方取引先名', '')) if pd.notna(row.get('借方取引先名', '')) else '',
                '借方備考': str(row.get('借方備考', '')) if pd.notna(row.get('借方備考', '')) else '',
                '借方メモ': str(row.get('借方メモ', '')) if pd.notna(row.get('借方メモ', '')) else '',
                '取引ID': trans_id
            }
            edited_data.append(row_data)
        
        if edited_data:
            # データエディターで編集可能な表を表示
            edited_df = st.data_editor(
                pd.DataFrame(edited_data),
                column_config={
                    "予算項目": st.column_config.SelectboxColumn(
                        "予算項目",
                        help="割り当てる予算項目を選択",
                        width="medium",
                        options=budget_options,
                        required=True,
                    ),
                    "取引日": st.column_config.TextColumn("取引日", disabled=True, width="small"),
                    "借方部門": st.column_config.TextColumn("借方部門", disabled=True, width="small"), 
                    "借方勘定科目": st.column_config.TextColumn("借方勘定科目", disabled=True, width="medium"),
                    "借方金額": st.column_config.NumberColumn("借方金額", disabled=True, width="small"),
                    "借方取引先名": st.column_config.TextColumn("借方取引先名", disabled=True, width="medium"),
                    "借方備考": st.column_config.TextColumn("借方備考", disabled=True, width="medium"),
                    "借方メモ": st.column_config.TextColumn("借方メモ", disabled=True, width="medium"),
                    "取引ID": st.column_config.TextColumn("取引ID", disabled=True, width="small"),
                },
                hide_index=True,
                use_container_width=True
            )
            
            st.markdown("---")
            
            # 保存ボタン
            if st.button("💾 割り当てを保存", type="primary", use_container_width=True):
                updated_count = 0
                
                for i, (_, new_row) in enumerate(edited_df.iterrows()):
                    trans_id = transaction_ids[i]
                    new_selection = new_row['予算項目']
                    
                    # 取引金額を取得
                    original_row = transactions_filtered.iloc[i]
                    trans_amount = 0
                    if '借方金額' in original_row:
                        try:
                            trans_amount = float(original_row['借方金額'])
                        except (ValueError, TypeError):
                            trans_amount = 0
                    
                    if new_selection == "未割り当て":
                        # 割り当て解除
                        if trans_id in st.session_state.allocations:
                            del st.session_state.allocations[trans_id]
                            updated_count += 1
                    else:
                        # 新しい割り当て
                        if new_selection in budget_item_map:
                            budget_info = budget_item_map[new_selection]
                            st.session_state.allocations[trans_id] = {
                                'grant_name': budget_info['grant_name'],
                                'budget_item_id': budget_info['item_id'], 
                                'amount': trans_amount,
                                'transaction_amount': trans_amount
                            }
                            updated_count += 1
                
                if updated_count > 0:
                    # ファイルに保存
                    save_allocations_to_csv(st.session_state.allocations)
                    st.success(f"✅ {updated_count}件の割り当てを更新し、ファイルに保存しました")
                    st.rerun()
                else:
                    st.info("変更はありませんでした")
        else:
            st.info("表示する取引データがありません")
            
        # 割り当て後の状況表示
        st.markdown("---")
        st.subheader("📊 割り当て状況サマリー")
        
        if st.session_state.allocations:
            # 予算項目別の割り当て状況を集計
            summary_data = {}
            
            for trans_id, allocation in st.session_state.allocations.items():
                if isinstance(allocation, dict) and allocation.get('budget_item_id'):
                    item_id = allocation['budget_item_id']
                    amount = allocation.get('amount', 0)
                    
                    if item_id not in summary_data:
                        summary_data[item_id] = {
                            'grant_name': allocation.get('grant_name', ''),
                            'total_amount': 0,
                            'transaction_count': 0
                        }
                    
                    summary_data[item_id]['total_amount'] += amount
                    summary_data[item_id]['transaction_count'] += 1
            
            if summary_data:
                # 予算項目情報と合わせて表示
                summary_display_data = []
                
                for grant in st.session_state.grants:
                    if grant.get('budget_items'):
                        for item in grant['budget_items']:
                            item_id = item.get('id', f"GRANT{grant['id']}_{item['name']}")
                            
                            if item_id in summary_data:
                                allocated_amount = summary_data[item_id]['total_amount']
                                transaction_count = summary_data[item_id]['transaction_count']
                                remaining_amount = item['budget'] - allocated_amount
                                execution_rate = (allocated_amount / item['budget'] * 100) if item['budget'] > 0 else 0
                                
                                summary_display_data.append({
                                    "助成金": grant['name'],
                                    "予算項目": item['name'],
                                    "予算額": int(item['budget']),
                                    "割り当て額": int(allocated_amount),
                                    "残額": int(remaining_amount),
                                    "取引数": transaction_count,
                                    "執行率": f"{execution_rate:.1f}%"
                                })
                
                if summary_display_data:
                    st.markdown("**現在の割り当て状況:**")
                    summary_df = pd.DataFrame(summary_display_data)
                    st.dataframe(
                        summary_df, 
                        use_container_width=True,
                        column_config={
                            "予算額": st.column_config.NumberColumn("予算額"),
                            "割り当て額": st.column_config.NumberColumn("割り当て額"),
                            "残額": st.column_config.NumberColumn("残額"),
                        }
                    )
                    
                    # 簡易統計
                    total_transactions = sum([data['取引数'] for data in summary_display_data])
                    st.info(f"💡 現在 {len(summary_display_data)} 個の予算項目に {total_transactions} 件の取引が割り当てられています")
                else:
                    st.info("表示できる割り当て状況がありません")
            else:
                st.info("割り当てデータがありません")
        else:
            st.info("まだ取引の割り当てがありません。上記の表から予算項目を選択して割り当てを行ってください。")
    else:
        st.error("取引データがありません")

def show_bulk_allocation_page():
    st.header("🎯 一括取引割り当て")
    
    if st.session_state.transactions.empty:
        st.warning("取引データがありません。まずfreeeデータをアップロードしてください。")
        return
    
    # 【事】【管】で始まる取引のみフィルタリング（事前処理）
    transactions_filtered = st.session_state.transactions.copy()
    if '借方勘定科目' in transactions_filtered.columns:
        mask = transactions_filtered['借方勘定科目'].astype(str).str.startswith(('【事】', '【管】'))
        transactions_filtered = transactions_filtered[mask]
    
    if transactions_filtered.empty:
        st.warning("【事】【管】で始まる取引データがありません。")
        return
    
    if not st.session_state.grants:
        st.warning("助成金が登録されていません。割り当て操作を行うには、まず助成金を登録してください。")
        return
        
    # 🏗️ 左右2列レイアウト
    col_left, col_right = st.columns([1, 2])  # 左1:右2の比率
    
    with col_left:
        # 🎯 左列：助成金項目選択と詳細情報
        st.subheader("🎯 助成金項目選択")
        
        # 第1段階：助成金選択
        grant_options = ["選択してください"]
        grant_map = {}
        
        for grant in st.session_state.grants:
            grant_options.append(grant['name'])
            grant_map[grant['name']] = grant
        
        selected_grant_name = st.selectbox(
            "1️⃣ 助成金を選択してください",
            options=grant_options,
            key="bulk_grant_select"
        )
        
        if selected_grant_name == "選択してください":
            st.info("👆 上記から助成金を選択してください")
            return
        
        # 選択された助成金を取得
        selected_grant = grant_map[selected_grant_name]
        
        # 第2段階：予算項目選択
        if not selected_grant.get('budget_items'):
            st.warning("選択された助成金には予算項目が設定されていません。")
            return
        
        budget_item_options = ["選択してください"]
        budget_item_map = {}
        
        for item in selected_grant['budget_items']:
            budget_item_options.append(item['name'])
            budget_item_map[item['name']] = {
                'grant': selected_grant,
                'item': item,
                'grant_name': selected_grant['name'],
                'item_id': item.get('id', f"GRANT{selected_grant['id']}_{item['name']}")
            }
        
        selected_budget_item = st.selectbox(
            "2️⃣ 予算項目を選択してください",
            options=budget_item_options,
            key="bulk_budget_item_select"
        )
        
        if selected_budget_item == "選択してください":
            st.info("👆 上記から予算項目を選択してください")
            return
        
        # 選択された項目の情報を取得
        selected_info = budget_item_map[selected_budget_item]
        grant = selected_info['grant']
        item = selected_info['item']
        item_id = selected_info['item_id']
        
        st.markdown("---")
        
        # 📊 選択項目の詳細情報
        st.markdown("**💰 助成金情報**")
        st.write(f"**助成金名：** {grant['name']}")
        st.write(f"**期間：** {grant['start_date']} ～ {grant['end_date']}")
        st.write(f"**総予算：** ¥{grant['total_budget']:,}")
        
        # 助成金全体の割り当て状況
        grant_allocated = 0
        for trans_id, allocation in st.session_state.allocations.items():
            if isinstance(allocation, dict) and allocation.get('grant_name') == grant['name']:
                grant_allocated += allocation.get('amount', 0)
        
        grant_remaining = grant['total_budget'] - grant_allocated
        st.write(f"**割当額：** ¥{grant_allocated:,}")
        st.write(f"**残額：** ¥{grant_remaining:,}")
        
        st.markdown("---")
        
        st.markdown("**📋 予算項目情報**")
        st.write(f"**予算項目名：** {item['name']}")
        st.write(f"**項目予算額：** ¥{item['budget']:,}")
        
        # 現在の割り当て状況を計算
        allocated_amount = 0
        allocated_transactions = []
        
        for trans_id, allocation in st.session_state.allocations.items():
            if isinstance(allocation, dict) and allocation.get('budget_item_id') == item_id:
                allocated_amount += allocation.get('amount', 0)
                allocated_transactions.append(trans_id)
        
        remaining_amount = item['budget'] - allocated_amount
        execution_rate = (allocated_amount / item['budget'] * 100) if item['budget'] > 0 else 0
        
        st.write(f"**割当額：** ¥{allocated_amount:,}")
        st.write(f"**残額：** ¥{remaining_amount:,}")
        st.write(f"**執行率：** {execution_rate:.1f}%")
        
        st.markdown("---")
        
        # 📊 この予算項目の既存割り当て取引一覧
        st.markdown("**✅ 既存割り当て取引**")
        
        if allocated_transactions:
            allocated_display_data = []
            
            for trans_id in allocated_transactions:
                # 元の取引データから詳細情報を取得
                if not st.session_state.transactions.empty:
                    if '_' in trans_id:
                        journal_num, line_num = trans_id.rsplit('_', 1)
                        trans_row = st.session_state.transactions[
                            (st.session_state.transactions['仕訳番号'].astype(str) == journal_num) &
                            (st.session_state.transactions['仕訳行番号'].astype(str) == line_num)
                        ]
                        
                        if not trans_row.empty:
                            row = trans_row.iloc[0]
                            
                            # 取引金額を取得
                            amount = 0
                            if '借方金額' in row:
                                try:
                                    amount = float(row['借方金額'])
                                except (ValueError, TypeError):
                                    amount = 0
                            
                            # 取引日の処理
                            transaction_date = ''
                            if pd.notna(row.get('取引日', '')):
                                try:
                                    date_obj = pd.to_datetime(row['取引日'])
                                    transaction_date = date_obj.strftime('%Y-%m-%d')
                                except:
                                    transaction_date = str(row.get('取引日', ''))
                            
                            allocated_display_data.append({
                                '取引日': transaction_date,
                                '借方勘定科目': str(row.get('借方勘定科目', ''))[:20] + "..." if len(str(row.get('借方勘定科目', ''))) > 20 else str(row.get('借方勘定科目', '')),
                                '借方金額': int(amount) if amount > 0 else 0,
                                '取引ID': trans_id,
                            })
            
            if allocated_display_data:
                st.dataframe(
                    pd.DataFrame(allocated_display_data),
                    use_container_width=True,
                    column_config={
                        "取引日": st.column_config.TextColumn("取引日", width="small"),
                        "借方勘定科目": st.column_config.TextColumn("借方勘定科目", width="medium"),
                        "借方金額": st.column_config.NumberColumn("借方金額", width="small"),
                        "取引ID": st.column_config.TextColumn("取引ID", width="small"),
                    },
                    hide_index=True
                )
                
                st.info(f"💡 現在{len(allocated_display_data)}件の取引が割り当て済みです")
                
                # 割り当て解除機能（オプション）
                if st.button("🗑️ この予算項目の割り当てを全て解除", key="bulk_clear"):
                    for trans_id in allocated_transactions:
                        if trans_id in st.session_state.allocations:
                            del st.session_state.allocations[trans_id]
                    
                    # ファイルに保存
                    save_allocations_to_csv(st.session_state.allocations)
                    st.success("✅ 割り当てを解除し、ファイルに保存しました")
                    st.rerun()
            else:
                st.info("取引詳細データが見つかりません")
        else:
            st.info("この予算項目にはまだ取引が割り当てられていません")
    
    with col_right:
        # 📋 右列：取引一覧と一括割り当て
        st.subheader("📋 取引一覧（全件表示）")
        
        # 全ての取引を表示（割り当て状況含む）
        all_transaction_data = []
        
        for idx, (_, row) in enumerate(transactions_filtered.iterrows()):
            # 取引IDを生成
            trans_id = f"{row['仕訳番号']}_{row['仕訳行番号']}"
            
            # 取引金額を取得
            amount = 0
            if '借方金額' in row:
                try:
                    amount = float(row['借方金額'])
                except (ValueError, TypeError):
                    amount = 0
            
            # 取引日の処理
            transaction_date = ''
            if pd.notna(row.get('取引日', '')):
                try:
                    date_obj = pd.to_datetime(row['取引日'])
                    transaction_date = date_obj.strftime('%Y-%m-%d')
                except:
                    transaction_date = str(row.get('取引日', ''))
            
            # 割り当て状況を確認
            allocated_info = ""
            is_allocated = trans_id in st.session_state.allocations
            
            if is_allocated:
                allocation = st.session_state.allocations[trans_id]
                if isinstance(allocation, dict):
                    grant_name = allocation.get('grant_name', '')
                    # 予算項目名を取得
                    budget_item_name = ""
                    for grant_check in st.session_state.grants:
                        if grant_check['name'] == grant_name:
                            for item_check in grant_check.get('budget_items', []):
                                if item_check.get('id') == allocation.get('budget_item_id'):
                                    budget_item_name = item_check['name']
                                    break
                            break
                    allocated_info = f"✅ {grant_name} - {budget_item_name}" if budget_item_name else f"✅ {grant_name}"
                else:
                    allocated_info = f"✅ {str(allocation)}"
            
            all_transaction_data.append({
                'select': False,
                '割り当て状況': allocated_info if is_allocated else "⚪ 未割り当て",
                '取引日': transaction_date,
                '借方部門': str(row.get('借方部門', '')),
                '借方勘定科目': str(row.get('借方勘定科目', '')),
                '借方金額': int(amount) if amount > 0 else 0,
                '借方取引先名': str(row.get('借方取引先名', '')),
                '借方備考': str(row.get('借方備考', '')),
                '取引ID': trans_id,  # 一番右に移動
            })
        
        if all_transaction_data:
            # チェックボックス付きの表を表示
            edited_df = st.data_editor(
                pd.DataFrame(all_transaction_data),
                column_config={
                    "select": st.column_config.CheckboxColumn("選択", default=False, width="small"),
                    "割り当て状況": st.column_config.TextColumn("割り当て状況", disabled=True, width="large"),
                    "取引日": st.column_config.TextColumn("取引日", disabled=True, width="small"),
                    "借方部門": st.column_config.TextColumn("借方部門", disabled=True, width="small"),
                    "借方勘定科目": st.column_config.TextColumn("借方勘定科目", disabled=True, width="medium"),
                    "借方金額": st.column_config.NumberColumn("借方金額", disabled=True, width="small"),
                    "借方取引先名": st.column_config.TextColumn("借方取引先名", disabled=True, width="medium"),
                    "借方備考": st.column_config.TextColumn("借方備考", disabled=True, width="medium"),
                    "取引ID": st.column_config.TextColumn("取引ID", disabled=True, width="small"),
                },
                hide_index=True,
                use_container_width=True,
                key="bulk_all_transaction_selector"
            )
            
            allocated_count = len([d for d in all_transaction_data if d['割り当て状況'].startswith('✅')])
            unallocated_count = len([d for d in all_transaction_data if d['割り当て状況'].startswith('⚪')])
            st.info(f"💡 全{len(all_transaction_data)}件の取引を表示中（✅ 割り当て済み: {allocated_count}件、⚪ 未割り当て: {unallocated_count}件）")
            
            # 🎯 一括割り当て操作ボタン
            selected_transactions = edited_df[edited_df['select'] == True] if not edited_df.empty else pd.DataFrame()
            selected_count = len(selected_transactions)
            
            if selected_count > 0:
                if st.button(f"🎯 選択した{selected_count}件を一括割り当て", type="primary", use_container_width=True):
                    assigned_count = 0
                    
                    for _, row in selected_transactions.iterrows():
                        trans_id = row['取引ID']
                        trans_amount = row['借方金額']
                        
                        st.session_state.allocations[trans_id] = {
                            'grant_name': grant['name'],
                            'budget_item_id': item_id,
                            'amount': trans_amount,
                            'transaction_amount': trans_amount
                        }
                        assigned_count += 1
                    
                    if assigned_count > 0:
                        # ファイルに保存
                        save_allocations_to_csv(st.session_state.allocations)
                        st.success(f"✅ {assigned_count}件の取引を「{selected_grant_name} - {selected_budget_item}」に割り当て、ファイルに保存しました！")
                        st.rerun()
            else:
                st.info("💡 上記の取引一覧で取引を選択してから一括割り当てを実行してください")
        else:
            st.info("表示する取引データがありません")



def show_data_download_page():
    st.header("💾 データダウンロード")
    st.markdown("各種データのダウンロード・アップロード・管理を一括で行えます。")
    
    # ダウンロード機能
    st.subheader("📥 データダウンロード")
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("**💰 助成金データ**")
        
        # 保存とダウンロードボタンを分ける
        save_col1, download_col1 = st.columns(2)
        with save_col1:
            if st.button("💾 ファイルに保存", type="primary", key="save_grants"):
                save_grants_to_csv(st.session_state.grants)
        
        with download_col1:
            if st.session_state.grants:
                # 助成金データをCSV形式で準備
                grants_data = []
                for grant in st.session_state.grants:
                    budget_items_str = "; ".join([
                        f"{item.get('id', 'NO_ID')}:{item['name']}:¥{item['budget']:,}" 
                        for item in grant.get('budget_items', [])
                    ])
                    
                    grants_data.append({
                        'id': grant['id'],
                        'name': grant['name'],
                        'source': grant['source'],
                        'total_budget': grant['total_budget'],
                        'start_date': grant['start_date'],
                        'end_date': grant['end_date'],
                        'description': grant['description'],
                        'budget_items': budget_items_str,
                        'created_at': grant['created_at']
                    })
                
                df_grants = pd.DataFrame(grants_data)
                csv_grants = df_grants.to_csv(index=False, encoding='utf-8-sig')
                
                st.download_button(
                    label="📥 CSVダウンロード",
                    data=csv_grants,
                    file_name=f"grants_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                    mime="text/csv",
                    key="download_grants"
                )
            else:
                st.info("ダウンロードできるデータがありません")
                
        st.info(f"現在登録数: {len(st.session_state.grants)}件")
    
    with col2:
        st.markdown("**🔗 割り当てデータ**")
        
        # 保存とダウンロードボタンを分ける
        save_col2, download_col2 = st.columns(2)
        with save_col2:
            if st.button("💾 ファイルに保存", type="primary", key="save_allocations"):
                save_allocations_to_csv(st.session_state.allocations)
        
        with download_col2:
            if st.session_state.allocations:
                # 割り当てデータをCSV形式で準備
                allocation_data = []
                for trans_id, allocation_info in st.session_state.allocations.items():
                    if isinstance(allocation_info, dict):
                        allocation_data.append({
                            "取引ID": trans_id,
                            "割り当て助成金": allocation_info.get('grant_name', ''),
                            "予算項目ID": allocation_info.get('budget_item_id', ''),
                            "割り当て金額": allocation_info.get('amount', 0),
                            "取引金額": allocation_info.get('transaction_amount', 0)
                        })
                    else:
                        allocation_data.append({
                            "取引ID": trans_id,
                            "割り当て助成金": allocation_info,
                            "予算項目ID": '',
                            "割り当て金額": 0,
                            "取引金額": 0
                        })
                
                df_allocations = pd.DataFrame(allocation_data)
                csv_allocations = df_allocations.to_csv(index=False, encoding='utf-8-sig')
                
                st.download_button(
                    label="📥 CSVダウンロード",
                    data=csv_allocations,
                    file_name=f"allocations_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                    mime="text/csv",
                    key="download_allocations"
                )
            else:
                st.info("ダウンロードできるデータがありません")
                
        st.info(f"現在割り当て数: {len(st.session_state.allocations)}件")
    
    with col3:
        st.markdown("**📊 取引データ**")
        
        if not st.session_state.transactions.empty:
            # 保存とダウンロードボタンを分ける
            save_col3, download_col3 = st.columns(2)
            
            with save_col3:
                if st.button("💾 ファイルに保存", type="primary", key="save_transactions"):
                    save_transactions_to_csv(st.session_state.transactions)
            
            with download_col3:
                csv_data = st.session_state.transactions.to_csv(index=False, encoding='utf-8-sig')
                st.download_button(
                    label="📥 CSVダウンロード",
                    data=csv_data,
                    file_name=f"transactions_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                    mime="text/csv",
                    key="download_transactions"
                )
            
            st.info(f"現在データ数: {len(st.session_state.transactions)}件")
        else:
            st.warning("取引データがありません")
    
    st.markdown("---")
    
    # アップロード機能
    st.subheader("📤 データアップロード")
    
    upload_col1, upload_col2 = st.columns(2)
    
    with upload_col1:
        st.markdown("**💰 助成金データアップロード**")
        st.info("Excel等で編集した助成金データをCSVでアップロード")
        
        grants_file = st.file_uploader(
            "助成金データCSVファイル", 
            type=['csv'], 
            key="grants_upload",
            help="grants_data.csv形式のファイルをアップロードしてください"
        )
        
        if grants_file is not None:
            if st.button("🔄 助成金データを更新", type="primary", key="update_grants"):
                st.session_state.grants = load_grants_from_csv()
                st.success("助成金データが更新されました")
                st.rerun()
    
    with upload_col2:
        st.markdown("**🔗 割り当てデータアップロード**")
        st.info("Excel等で編集した割り当てデータをCSVでアップロード")
        
        allocations_file = st.file_uploader(
            "割り当てデータCSVファイル", 
            type=['csv'], 
            key="allocations_upload",
            help="allocations_data.csv形式のファイルをアップロードしてください"
        )
        
        if allocations_file is not None:
            if st.button("🔄 割り当てデータを更新", type="primary", key="update_allocations"):
                st.session_state.allocations = load_allocations_from_csv()
                st.success("割り当てデータが更新されました")
                st.rerun()
    
    st.markdown("---")
    
    # データ管理機能
    st.subheader("🗑️ データ管理")
    
    st.warning("⚠️ 注意: 以下の操作は元に戻せません")
    
    manage_col1, manage_col2, manage_col3 = st.columns(3)
    
    with manage_col1:
        if st.button("🗑️ 助成金データをクリア", key="clear_grants"):
            st.session_state.grants = []
            st.success("助成金データをクリアしました")
            st.rerun()
    
    with manage_col2:
        if st.button("🗑️ 割り当てデータをクリア", key="clear_allocations"):
            st.session_state.allocations = {}
            st.success("割り当てデータをクリアしました")
            st.rerun()
    
    with manage_col3:
        if st.button("🗑️ 全データをクリア", key="clear_all"):
            st.session_state.grants = []
            st.session_state.allocations = {}
            st.session_state.transactions = pd.DataFrame()
            st.success("全データをクリアしました")
            st.rerun()

if __name__ == "__main__":
    main()