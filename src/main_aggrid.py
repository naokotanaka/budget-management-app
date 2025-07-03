import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime, date
import io
import json
import os
from st_aggrid import AgGrid, GridOptionsBuilder, DataReturnMode, GridUpdateMode, JsCode

st.set_page_config(
    page_title="NPO法人ながいく - 助成金管理システム（AgGrid版）",
    page_icon="💰",
    layout="wide",
    initial_sidebar_state="expanded"
)

# カスタムCSS
st.markdown("""
<style>
.metric-card {
    background-color: #f0f2f6;
    padding: 1rem;
    border-radius: 0.5rem;
    border-left: 4px solid #1f77b4;
    margin: 0.5rem 0;
}
.success-card {
    background-color: #d4edda;
    padding: 1rem;
    border-radius: 0.5rem;
    border-left: 4px solid #28a745;
    margin: 0.5rem 0;
}
.warning-card {
    background-color: #fff3cd;
    padding: 1rem;
    border-radius: 0.5rem;
    border-left: 4px solid #ffc107;
    margin: 0.5rem 0;
}
</style>
""", unsafe_allow_html=True)

def format_currency(value, prefix="¥"):
    """通貨フォーマット関数"""
    if pd.isna(value) or value == '':
        return ''
    return f"{prefix}{value:,.0f}"

def format_percentage(value):
    """パーセンテージフォーマット関数"""
    if pd.isna(value) or value == '':
        return ''
    return f"{value:.1f}%"

def safe_parse_amount(amount_str):
    """金額文字列を安全に数値に変換する"""
    if not amount_str:
        return 0
    
    # 文字列に変換
    amount_str = str(amount_str).strip()
    
    # 空文字列やNaNの場合は0を返す
    if not amount_str or amount_str.lower() == 'nan':
        return 0
    
    try:
        # 不正な文字を除去
        # バックスラッシュ、円マーク、カンマを削除
        cleaned_str = amount_str.replace('\\', '').replace('¥', '').replace(',', '').replace('￥', '')
        
        # 先頭と末尾の空白を削除
        cleaned_str = cleaned_str.strip()
        
        # 空文字列になった場合は0を返す
        if not cleaned_str:
            return 0
        
        # 数値に変換
        return int(float(cleaned_str))
    except (ValueError, TypeError) as e:
        # エラーが発生した場合は詳細をログに出力して0を返す
        print(f"金額変換エラー: '{amount_str}' -> エラー: {e}")
        return 0

def save_grants_to_csv(grants: list, filename: str = "grants_data.csv") -> None:
    """助成金データをCSVファイルに保存する"""
    if not grants:
        return
    
    # 助成金データをフラット化
    grants_data = []
    for grant in grants:
        # 予算項目を文字列として結合（ID付き + 説明）
        budget_items_str = "; ".join([
            f"{item.get('id', 'NO_ID')}:{item['name']}:¥{item['budget']:,}:{item.get('description', '')}" 
            for item in grant.get('budget_items', [])
        ])
        
        grants_data.append({
            'id': grant['id'],
            'name': grant['name'],
            'source': grant.get('source', ''),  # 助成元は空文字列でも保存
            'total_budget': grant['total_budget'],
            'start_date': grant['start_date'],
            'end_date': grant['end_date'],
            'description': grant['description'],
            'budget_items': budget_items_str,
            'created_at': grant['created_at']
        })
    
    df = pd.DataFrame(grants_data)
    # 日本語環境での文字化け対策（Excel対応優先）
    try:
        # 最初にBOM付きUTF-8を試す（Excelが日本語を正しく認識しやすい）
        with open(filename, 'w', encoding='utf-8-sig', newline='') as f:
            df.to_csv(f, index=False)
        st.success(f"✅ 助成金データを {filename} に保存しました（UTF-8 BOM形式）")
    except Exception as e:
        try:
            # フォールバック：Shift_JIS
            with open(filename, 'w', encoding='shift_jis', newline='') as f:
                df.to_csv(f, index=False, errors='ignore')
            st.success(f"✅ 助成金データを {filename} に保存しました（Shift_JIS形式）")
        except Exception as e2:
            st.error(f"❌ ファイル保存エラー: {str(e2)}")

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
                        if len(parts) >= 4:
                            # 新形式: ID:名前:¥金額:説明
                            item_id, name, budget_str, description = parts[0], parts[1], parts[2], parts[3]
                            budget = safe_parse_amount(budget_str)
                            budget_items.append({
                                "id": item_id,
                                "name": name, 
                                "budget": budget,
                                "description": description
                            })
                        elif len(parts) >= 3:
                            # 旧形式: ID:名前:¥金額
                            item_id, name, budget_str = parts[0], parts[1], parts[2]
                            budget = safe_parse_amount(budget_str)
                            budget_items.append({
                                "id": item_id,
                                "name": name, 
                                "budget": budget,
                                "description": ""
                            })
                        elif len(parts) == 2:
                            # 旧形式: 名前:¥金額
                            name, budget_str = parts[0], parts[1]
                            budget = safe_parse_amount(budget_str)
                            # 予算項目IDを自動生成
                            item_id = f"GRANT{int(row['id'])}_ITEM{item_index}"
                            budget_items.append({
                                "id": item_id,
                                "name": name, 
                                "budget": budget,
                                "description": ""
                            })
                        item_index += 1
            
            description_value = row['description']
            description = str(description_value) if description_value is not None and str(description_value).strip() != 'nan' else ''
            
            grant = {
                'id': int(row['id']),
                'name': row['name'],
                'source': row['source'],
                'total_budget': safe_parse_amount(row['total_budget']),
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

def initialize_session_state():
    """セッション状態を初期化し、CSVファイルから自動読み込み"""
    if 'grants' not in st.session_state:
        st.session_state.grants = load_grants_from_csv()
    
    if 'transactions' not in st.session_state:  # transactions_dfではなくtransactions
        st.session_state.transactions = load_transactions_from_csv()
    
    if 'allocations' not in st.session_state:
        st.session_state.allocations = load_allocations_from_csv()

def save_allocations_to_csv(allocations: dict, filename: str = "allocations_data.csv") -> None:
    """割り当てデータをCSVファイルに保存する（拡張版：部分金額割り当て対応）"""
    print(f"🔍 save_allocations_to_csv: 受信データ件数 = {len(allocations)}")
    
    # 空のデータでも保存処理を実行（ファイルを空にする必要がある）
    if not allocations:
        print("🔍 save_allocations_to_csv: データが空 - 空のファイルを作成します")
        try:
            # 空のCSVファイルを作成（ヘッダーのみ）
            empty_df = pd.DataFrame(columns=['取引ID', '割り当て助成金', '予算項目ID', '割り当て金額', '取引金額'])
            
            import tempfile
            import shutil
            
            with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8-sig', newline='', delete=False, suffix='.csv') as temp_file:
                empty_df.to_csv(temp_file, index=False)
                temp_filename = temp_file.name
            
            # 既存ファイルを削除してから新しいファイルに置き換え
            if os.path.exists(filename):
                try:
                    os.remove(filename)
                except PermissionError:
                    import time
                    backup_filename = f"{filename}.backup_{int(time.time())}"
                    shutil.move(temp_filename, backup_filename)
                    print(f"🔍 save_allocations_to_csv: 権限問題のためバックアップファイルに保存 - {backup_filename}")
                    st.warning(f"⚠️ ファイルが使用中のため、バックアップファイル {backup_filename} に保存しました")
                    return
            
            shutil.move(temp_filename, filename)
            print(f"🔍 save_allocations_to_csv: 空ファイル作成成功 - {filename}")
            st.success(f"✅ 空の割り当てデータを {filename} に保存しました")
            return
        except Exception as e:
            print(f"🔍 save_allocations_to_csv: 空ファイル作成失敗 - {str(e)}")
            st.error(f"❌ 空ファイル作成エラー: {str(e)}")
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
    # 日本語環境での文字化け対策（Excel対応優先）
    try:
        import tempfile
        import shutil
        
        # 一時ファイルに書き込んでから移動する方式で権限問題を回避
        with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8-sig', newline='', delete=False, suffix='.csv') as temp_file:
            df.to_csv(temp_file, index=False)
            temp_filename = temp_file.name
        
        # 既存ファイルが存在する場合は削除
        if os.path.exists(filename):
            try:
                os.remove(filename)
            except PermissionError:
                # ファイルが使用中の場合、バックアップ名で保存
                import time
                backup_filename = f"{filename}.backup_{int(time.time())}"
                shutil.move(temp_filename, backup_filename)
                print(f"🔍 save_allocations_to_csv: 権限問題のためバックアップファイルに保存 - {backup_filename}")
                st.warning(f"⚠️ ファイルが使用中のため、バックアップファイル {backup_filename} に保存しました")
                return
        
        # 一時ファイルを目標ファイル名に移動
        shutil.move(temp_filename, filename)
        print(f"🔍 save_allocations_to_csv: UTF-8保存成功 - {len(df)}行を {filename} に保存")
        st.success(f"✅ 割り当てデータを {filename} に保存しました（UTF-8 BOM形式）")
        
    except Exception as e:
        print(f"🔍 save_allocations_to_csv: 改善版保存失敗 - {str(e)}")
        try:
            # フォールバック：直接書き込み（Shift_JIS）
            with open(filename, 'w', encoding='shift_jis', newline='') as f:
                df.to_csv(f, index=False, errors='ignore')
            print(f"🔍 save_allocations_to_csv: Shift_JIS保存成功 - {len(df)}行を {filename} に保存")
            st.success(f"✅ 割り当てデータを {filename} に保存しました（Shift_JIS形式）")
        except Exception as e2:
            print(f"🔍 save_allocations_to_csv: 全ての保存方法が失敗 - {str(e2)}")
            st.error(f"❌ ファイル保存エラー: {str(e2)}")

def load_allocations_from_csv(filename: str = "allocations_data.csv") -> dict:
    """CSVファイルから割り当てデータを読み込む（拡張版：部分金額割り当て対応）"""
    print(f"🔍 load_allocations_from_csv: ファイル {filename} から読み込み開始")
    if not os.path.exists(filename):
        print(f"🔍 load_allocations_from_csv: ファイル {filename} が存在しません")
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
        
        # 空のファイル（ヘッダーのみ）の場合
        if df.empty:
            print(f"🔍 load_allocations_from_csv: ファイルは空です（ヘッダーのみ）")
            return {}
        
        allocations = {}
        for _, row in df.iterrows():
            trans_id = str(row['取引ID'])
            
            # 新形式チェック（予算項目IDがある場合）
            if '予算項目ID' in df.columns and pd.notna(row.get('予算項目ID', '')) and row.get('予算項目ID', '') != '':
                allocations[trans_id] = {
                    'grant_name': row['割り当て助成金'],
                    'budget_item_id': row['予算項目ID'],
                    'amount': float(row.get('割り当て金額', 0)),
                    'transaction_amount': float(row.get('取引金額', 0))
                }
            else:
                # 旧形式：互換性のため
                allocations[trans_id] = row['割り当て助成金']
        
        print(f"🔍 load_allocations_from_csv: 読み込み完了 - {len(allocations)}件のデータを取得")
        return allocations
    except Exception as e:
        st.error(f"❌ 割り当てデータ読み込みエラー: {str(e)}")
        return {}

def save_transactions_to_csv(transactions: pd.DataFrame, filename: str = "transactions_data.csv") -> None:
    """取引データをCSVファイルに保存する"""
    if transactions.empty:
        return
    
    try:
        # 日本語環境での文字化け対策（Excel対応優先）
        try:
            # 最初にBOM付きUTF-8を試す（Excelが日本語を正しく認識しやすい）
            with open(filename, 'w', encoding='utf-8-sig', newline='') as f:
                transactions.to_csv(f, index=False)
            st.success(f"✅ 取引データを {filename} に保存しました（UTF-8 BOM形式）")
        except Exception as e:
            try:
                # フォールバック：Shift_JIS
                with open(filename, 'w', encoding='shift_jis', newline='') as f:
                    transactions.to_csv(f, index=False, errors='ignore')
                st.success(f"✅ 取引データを {filename} に保存しました（Shift_JIS形式）")
            except Exception as e2:
                st.error(f"❌ ファイル保存エラー: {str(e2)}")
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

def show_dashboard():
    """AgGrid対応のダッシュボードを表示"""
    st.header("🏠 ダッシュボード")
    
    if not st.session_state.grants:
        st.warning("⚠️ 助成金データが登録されていません。まず助成金を登録してください。")
        return
    
    # サマリー情報の計算
    total_grants = len(st.session_state.grants)
    total_budget = sum(grant['total_budget'] for grant in st.session_state.grants)
    
    # 使用済み金額の計算
    used_budget = 0
    for grant in st.session_state.grants:
        for budget_item in grant.get('budget_items', []):
            # 該当する取引から使用済み金額を計算
            item_used = 0
            for trans_id, allocation in st.session_state.allocations.items():
                if isinstance(allocation, dict):
                    if allocation.get('budget_item_id') == budget_item['id']:
                        item_used += allocation.get('amount', 0)
            used_budget += item_used
    
    remaining_budget = total_budget - used_budget
    usage_percentage = (used_budget / total_budget * 100) if total_budget > 0 else 0
    
    # メトリクス表示
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        st.metric("助成金数", f"{total_grants}件")
    
    with col2:
        st.metric("総予算額", f"¥{total_budget:,}")
    
    with col3:
        st.metric("使用済み", f"¥{used_budget:,}")
    
    with col4:
        st.metric("残高", f"¥{remaining_budget:,}")
    
    # 進捗率バー
    st.markdown("### 📊 全体進捗率")
    progress_bar = st.progress(usage_percentage / 100)
    st.write(f"**{usage_percentage:.1f}%** ({used_budget:,}円 / {total_budget:,}円)")
    
    # 助成金別の詳細表示（AgGrid使用）
    st.markdown("### 💼 助成金別詳細")
    
    # 助成金データを表形式で準備
    dashboard_data = []
    for grant in st.session_state.grants:
        grant_used = 0
        # この助成金の使用済み金額を計算
        for budget_item in grant.get('budget_items', []):
            item_used = 0
            for trans_id, allocation in st.session_state.allocations.items():
                if isinstance(allocation, dict):
                    if allocation.get('budget_item_id') == budget_item['id']:
                        item_used += allocation.get('amount', 0)
            grant_used += item_used
        
        grant_remaining = grant['total_budget'] - grant_used
        grant_progress = (grant_used / grant['total_budget'] * 100) if grant['total_budget'] > 0 else 0
        
        dashboard_data.append({
            '助成金名': grant['name'],
            '総予算額': grant['total_budget'],
            '使用済み': grant_used,
            '残高': grant_remaining,
            '進捗率': grant_progress,
            '期間': f"{grant['start_date']} ～ {grant['end_date']}"
        })
    
    if dashboard_data:
        df_dashboard = pd.DataFrame(dashboard_data)
        
        # データをフォーマットして表示用に準備
        df_display = df_dashboard.copy()
        df_display['総予算額'] = df_display['総予算額'].apply(format_currency)
        df_display['使用済み'] = df_display['使用済み'].apply(format_currency)
        df_display['残高'] = df_display['残高'].apply(format_currency)
        df_display['進捗率'] = df_display['進捗率'].apply(format_percentage)
        
        # 進捗率による色分け用の列を追加
        def get_progress_status(progress_value):
            # 元の数値を取り出す
            if isinstance(progress_value, str):
                numeric_value = float(progress_value.replace('%', ''))
            else:
                numeric_value = progress_value
                
            if numeric_value >= 90:
                return "🔴 危険"
            elif numeric_value >= 70:
                return "🟡 警告"
            elif numeric_value >= 50:
                return "🔵 注意"
            else:
                return "🟢 安全"
        
        df_display['状態'] = df_dashboard['進捗率'].apply(get_progress_status)
        
        # AgGridの設定（シンプル版）
        gb = GridOptionsBuilder.from_dataframe(df_display)
        gb.configure_default_column(
            groupable=True,
            value=True,
            enableRowGroup=True,
            editable=False,
            resizable=True
        )
        
        # 列幅の調整
        gb.configure_column('助成金名', width=200)
        gb.configure_column('総予算額', width=120, cellStyle={'textAlign': 'right'})
        gb.configure_column('使用済み', width=120, cellStyle={'textAlign': 'right'})
        gb.configure_column('残高', width=120, cellStyle={'textAlign': 'right'})
        gb.configure_column('進捗率', width=100, cellStyle={'textAlign': 'right'})
        gb.configure_column('状態', width=100)
        gb.configure_column('期間', width=200)
        
        gb.configure_pagination(paginationAutoPageSize=True)
        gb.configure_side_bar()
        
        gridOptions = gb.build()
        
        # AgGrid表示
        grid_response = AgGrid(
            df_display,
            gridOptions=gridOptions,
            data_return_mode=DataReturnMode.AS_INPUT,
            update_mode=GridUpdateMode.MODEL_CHANGED,
            fit_columns_on_grid_load=True,
            theme='alpine',
            height=400,
            width='100%'
        )
        
        # グラフ表示
        st.markdown("### 📈 予算使用状況グラフ")
        
        col1, col2 = st.columns(2)
        
        with col1:
            # 助成金別の進捗率（横棒グラフ）
            fig_progress = px.bar(
                df_dashboard,
                x='進捗率',
                y='助成金名',
                orientation='h',
                title='助成金別進捗率',
                labels={'進捗率': '進捗率 (%)', '助成金名': '助成金'},
                color='進捗率',
                color_continuous_scale='RdYlGn_r'
            )
            fig_progress.update_layout(height=400)
            st.plotly_chart(fig_progress, use_container_width=True)
        
        with col2:
            # 予算構成（円グラフ）
            fig_pie = px.pie(
                df_dashboard,
                values='総予算額',
                names='助成金名',
                title='予算構成'
            )
            fig_pie.update_layout(height=400)
            st.plotly_chart(fig_pie, use_container_width=True)

def show_upload_page():
    st.header("📂 freee データアップロード")
    
    # Freeeからのデータ取得手順を詳細に説明
    with st.expander("📖 Freeeからのデータ取得手順（詳細）", expanded=False):
        st.markdown("""
        ### 🔗 Freeeデータエクスポート手順
        
        #### **Step 1: 仕訳帳エクスポートページにアクセス**
        下記リンクをクリックして、Freeeの仕訳帳エクスポートページを開いてください：
        
        🔗 **[Freee 仕訳帳エクスポート](https://secure.freee.co.jp/reports/journals/export?page=1&per_page=50&order_by=txn_date&direction=asc&start_date=2025-04-01&end_date=2026-03-31)**
        
        #### **Step 2: エクスポート設定**
        1. **テンプレートの選択**: 「予算用 分割無し」を選択
        2. **文字コードの設定**: 「UTF-8(BOMつき)」を選択
        3. **出力を開始**ボタンをクリック
        
        #### **Step 3: ダウンロード**
        処理完了後、メールで通知されます。その後：
        
        🔗 **[Freee アウトプット一覧](https://secure.freee.co.jp/reports/output_list)**
        
        上記リンクから生成されたCSVファイルをダウンロードしてください。
        
        ---
        
        ### ⚠️ 重要な注意点
        - エクスポート処理には時間がかかる場合があります
        - 完了通知がメールで届くまでお待ちください
        - 文字コードは必ず「UTF-8(BOMつき)」を選択してください
        """)
    
    st.markdown("""
    ### 📋 アップロード手順
    1. 上記手順でfreeeから取引データをCSV形式でエクスポート
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
            
            # データプレビュー（AgGrid使用）
            st.subheader("📋 データプレビュー")
            
            # 先頭10行を表示
            preview_df = df.head(10)
            
            # AgGridでプレビュー表示
            gb = GridOptionsBuilder.from_dataframe(preview_df)
            gb.configure_default_column(
                groupable=False,
                value=True,
                enableRowGroup=False,
                editable=False,
                resizable=True
            )
            gb.configure_pagination(paginationAutoPageSize=True)
            
            gridOptions = gb.build()
            
            AgGrid(
                preview_df,
                gridOptions=gridOptions,
                data_return_mode=DataReturnMode.AS_INPUT,
                update_mode=GridUpdateMode.MODEL_CHANGED,
                fit_columns_on_grid_load=True,
                theme='alpine',
                height=300,
                width='100%'
            )
            
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
                start_date = st.date_input("開始日")
                end_date = st.date_input("終了日")
            
            with col2:
                description = st.text_area("概要・備考")
            
            # 予算項目設定
            st.subheader("📊 予算項目設定")
            st.info("💡 総予算額は予算項目の合計で自動計算されます")
            
            budget_items = []
            
            # 動的に予算項目を追加できるセッション状態を管理
            if 'temp_budget_items_count' not in st.session_state:
                st.session_state.temp_budget_items_count = 3
            
            col_add, col_remove = st.columns([1, 1])
            with col_add:
                if st.form_submit_button("➕ 予算項目を追加"):
                    st.session_state.temp_budget_items_count += 1
                    st.rerun()
            with col_remove:
                if st.session_state.temp_budget_items_count > 1:
                    if st.form_submit_button("➖ 予算項目を削除"):
                        st.session_state.temp_budget_items_count -= 1
                        st.rerun()
            
            total_budget_calculated = 0
            
            for i in range(int(st.session_state.temp_budget_items_count)):
                st.markdown(f"**予算項目 {i+1}**")
                col1, col2, col3 = st.columns([2, 2, 3])
                
                with col1:
                    item_name = st.text_input(f"項目名", key=f"item_name_{i}", placeholder="例：人件費")
                with col2:
                    item_budget = st.number_input(f"予算額", min_value=0, step=1000, key=f"item_budget_{i}", format="%d")
                with col3:
                    item_description = st.text_input(f"説明", key=f"item_desc_{i}", placeholder="予算項目の詳細説明")
                
                if item_name and item_budget > 0:
                    # 予算項目IDをシンプルな数字のみに変更
                    item_id = str(i + 1)
                    budget_items.append({
                        "id": item_id,
                        "name": item_name, 
                        "budget": item_budget,
                        "description": item_description if item_description else ""
                    })
                    total_budget_calculated += item_budget
            
            # 総予算額を表示（自動計算）
            st.markdown("---")
            st.markdown(f"**📊 総予算額（自動計算）: {format_currency(total_budget_calculated)}**")
            
            submitted = st.form_submit_button("💾 助成金を登録")
            
            if submitted and grant_name and total_budget_calculated > 0:
                new_grant = {
                    "id": len(st.session_state.grants) + 1,
                    "name": grant_name,
                    "source": "",  # 助成元フィールドを空に
                    "total_budget": total_budget_calculated,  # 自動計算された総予算額を使用
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
                # セッション状態をリセット
                st.session_state.temp_budget_items_count = 3
                st.rerun()
    
    # CSVファイルアップロード機能
    with st.expander("📤 CSVファイルアップロード", expanded=False):
        st.info("💡 Excel等で編集した助成金データをまとめてアップロードできます")
        
        upload_format = st.radio(
            "アップロード形式を選択:",
            ["Excel編集用（縦展開）", "通常形式"],
            key="upload_format_grant_management",
            horizontal=True,
            help="Excel編集用：1行1予算項目、通常形式：既存のbudget_items形式"
        )
        
        uploaded_file = st.file_uploader(
            "助成金CSVファイルを選択",
            type=['csv'],
            key="grants_csv_upload",
            help="選択した形式に対応するCSVファイルをアップロードしてください"
        )
        
        if uploaded_file is not None:
            # アップロード方法を選択
            col_option1, col_option2 = st.columns(2)
            
            with col_option1:
                if st.button("🔄 既存データを置換", type="primary", key="replace_grants"):
                    try:
                        if upload_format == "Excel編集用（縦展開）":
                            # 縦展開形式から読み込み
                            csv_content = uploaded_file.read().decode('utf-8-sig')
                            uploaded_grants = import_grants_vertical_format(csv_content)
                        else:
                            # 通常形式から読み込み（一時ファイルに保存してから読み込み）
                            with open("temp_upload_grants.csv", "wb") as f:
                                f.write(uploaded_file.getvalue())
                            uploaded_grants = load_grants_from_csv("temp_upload_grants.csv")
                            import os
                            os.remove("temp_upload_grants.csv")
                        
                        # 既存データを完全に置換
                        st.session_state.grants = uploaded_grants
                        save_grants_to_csv(st.session_state.grants)
                        st.success(f"✅ {len(uploaded_grants)}件の助成金データで置換しました")
                        st.rerun()
                        
                    except Exception as e:
                        st.error(f"❌ インポートエラー: {str(e)}")
                        st.info("ファイル形式を確認してください")
            
            with col_option2:
                if st.button("➕ 既存データに追加", key="append_grants"):
                    try:
                        if upload_format == "Excel編集用（縦展開）":
                            # 縦展開形式から読み込み
                            csv_content = uploaded_file.read().decode('utf-8-sig')
                            uploaded_grants = import_grants_vertical_format(csv_content)
                        else:
                            # 通常形式から読み込み
                            with open("temp_upload_grants.csv", "wb") as f:
                                f.write(uploaded_file.getvalue())
                            uploaded_grants = load_grants_from_csv("temp_upload_grants.csv")
                            import os
                            os.remove("temp_upload_grants.csv")
                        
                        # IDの重複を避けるため、新しいIDを割り当て
                        max_existing_id = max([g['id'] for g in st.session_state.grants], default=0)
                        for i, grant in enumerate(uploaded_grants):
                            grant['id'] = max_existing_id + i + 1
                        
                        # 既存データに追加
                        st.session_state.grants.extend(uploaded_grants)
                        save_grants_to_csv(st.session_state.grants)
                        st.success(f"✅ {len(uploaded_grants)}件の助成金データを追加しました")
                        st.rerun()
                        
                    except Exception as e:
                        st.error(f"❌ インポートエラー: {str(e)}")
                        st.info("ファイル形式を確認してください")
        
        # 使い方のヒント
        with st.expander("💡 使い方のヒント", expanded=False):
            st.markdown("""
            **Excel編集用（縦展開）形式:**
            - 1行1予算項目で編集しやすい形式
            - 列数が少なく、Excelでの編集に最適
            - 例：1つの助成金に3つの予算項目がある場合、3行のデータになります
            
            **通常形式:**
            - システム内部で使用している形式
            - budget_items列に複雑な文字列が含まれます
            
            **おすすめワークフロー:**
            1. 「データダウンロード」ページで「📊 Excel編集用」をダウンロード
            2. Excelで助成金・予算項目を編集（行の追加・削除・変更）
            3. CSVで保存
            4. ここで「Excel編集用（縦展開）」を選択してアップロード
            """)
    
    # 既存助成金一覧（AgGrid使用）
    st.subheader("📋 登録済み助成金一覧")
    
    if st.session_state.grants:
        for grant in st.session_state.grants:
            # 編集モードの確認
            editing_key = f"editing_grant_{grant['id']}"
            is_editing = st.session_state.get(editing_key, False)
            
            if is_editing:
                # 編集モード
                with st.expander(f"✏️ 編集中: {grant['name']}", expanded=True):
                    with st.form(f"edit_grant_form_{grant['id']}"):
                        col1, col2 = st.columns(2)
                        
                        with col1:
                            edit_grant_name = st.text_input("助成金名称", value=grant['name'], key=f"edit_name_{grant['id']}")
                            edit_start_date = st.date_input("開始日", value=pd.to_datetime(grant['start_date']).date(), key=f"edit_start_{grant['id']}")
                            edit_end_date = st.date_input("終了日", value=pd.to_datetime(grant['end_date']).date(), key=f"edit_end_{grant['id']}")
                        
                        with col2:
                            edit_description = st.text_area("概要・備考", value=grant.get('description', ''), key=f"edit_desc_{grant['id']}")
                        
                        # 予算項目編集
                        st.subheader("📊 予算項目編集")
                        st.info("💡 総予算額は予算項目の合計で自動計算されます")
                        
                        # 既存の予算項目を編集可能な状態で表示
                        edit_budget_items = []
                        edit_total_budget = 0
                        
                        # セッション状態に編集用の予算項目を保存
                        edit_items_key = f"edit_budget_items_{grant['id']}"
                        if edit_items_key not in st.session_state:
                            st.session_state[edit_items_key] = grant.get('budget_items', []).copy()
                        
                        col_add, col_remove = st.columns([1, 1])
                        with col_add:
                            if st.form_submit_button("➕ 予算項目を追加"):
                                new_item = {
                                    "id": str(len(st.session_state[edit_items_key]) + 1),
                                    "name": "",
                                    "budget": 0,
                                    "description": ""
                                }
                                st.session_state[edit_items_key].append(new_item)
                                st.rerun()
                        
                        with col_remove:
                            if len(st.session_state[edit_items_key]) > 1:
                                if st.form_submit_button("➖ 最後の項目を削除"):
                                    st.session_state[edit_items_key].pop()
                                    st.rerun()
                        
                        for i, item in enumerate(st.session_state[edit_items_key]):
                            st.markdown(f"**予算項目 {i+1}**")
                            col1, col2, col3 = st.columns([2, 2, 3])
                            
                            with col1:
                                item_name = st.text_input(f"項目名", value=item.get('name', ''), key=f"edit_item_name_{grant['id']}_{i}", placeholder="例：人件費")
                            with col2:
                                item_budget = st.number_input(f"予算額", value=int(item.get('budget', 0)), min_value=0, step=1000, key=f"edit_item_budget_{grant['id']}_{i}", format="%d")
                            with col3:
                                item_description = st.text_input(f"説明", value=item.get('description', ''), key=f"edit_item_desc_{grant['id']}_{i}", placeholder="予算項目の詳細説明")
                            
                            if item_name and item_budget > 0:
                                edit_budget_items.append({
                                    "id": str(i + 1),
                                    "name": item_name,
                                    "budget": item_budget,
                                    "description": item_description
                                })
                                edit_total_budget += item_budget
                        
                        # 総予算額を表示（自動計算）
                        st.markdown("---")
                        st.markdown(f"**📊 総予算額（自動計算）: {format_currency(edit_total_budget)}**")
                        
                        col_save, col_cancel = st.columns(2)
                        with col_save:
                            submit_edit = st.form_submit_button("💾 変更を保存", type="primary")
                        with col_cancel:
                            cancel_edit = st.form_submit_button("❌ 編集をキャンセル")
                        
                        if submit_edit and edit_grant_name and edit_total_budget > 0:
                            # 助成金データを更新
                            for g in st.session_state.grants:
                                if g['id'] == grant['id']:
                                    g['name'] = edit_grant_name
                                    g['total_budget'] = edit_total_budget
                                    g['start_date'] = edit_start_date.isoformat()
                                    g['end_date'] = edit_end_date.isoformat()
                                    g['description'] = edit_description
                                    g['budget_items'] = edit_budget_items
                                    break
                            
                            # 自動保存
                            save_grants_to_csv(st.session_state.grants)
                            st.success("✅ 助成金データが更新されました！")
                            
                            # 編集モードを終了
                            del st.session_state[editing_key]
                            if edit_items_key in st.session_state:
                                del st.session_state[edit_items_key]
                            st.rerun()
                        
                        if cancel_edit:
                            # 編集モードを終了
                            del st.session_state[editing_key]
                            if edit_items_key in st.session_state:
                                del st.session_state[edit_items_key]
                            st.rerun()
            else:
                # 通常の表示モード
                with st.expander(f"💰 {grant['name']}"):
                    col1, col2, col3 = st.columns(3)
                    
                    with col1:
                        st.write(f"**総予算額:** {format_currency(grant['total_budget'])}")
                        st.write(f"**期間:** {grant['start_date']} ～ {grant['end_date']}")
                    
                    with col2:
                        st.write(f"**登録日:** {grant['created_at'][:10]}")
                        if grant['description']:
                            st.write(f"**概要:** {grant['description']}")
                    
                    with col3:
                        col_edit, col_delete = st.columns(2)
                        with col_edit:
                            if st.button(f"✏️ 編集", key=f"edit_{grant['id']}"):
                                st.session_state[f"editing_grant_{grant['id']}"] = True
                                st.rerun()
                        with col_delete:
                            if st.button(f"🗑️ 削除", key=f"delete_{grant['id']}"):
                                st.session_state.grants = [g for g in st.session_state.grants if g['id'] != grant['id']]
                                # 自動保存
                                save_grants_to_csv(st.session_state.grants)
                                st.success("助成金が削除されました")
                                st.rerun()
                    
                    if grant['budget_items']:
                        st.write("**予算項目:**")
                        # 予算項目をAgGridで表示（説明フィールド追加）
                        budget_items_display = []
                        for item in grant['budget_items']:
                            budget_items_display.append({
                                "ID": item.get('id', '未設定'),
                                "項目名": item['name'],
                                "予算額": int(item['budget']),
                                "説明": item.get('description', '')
                            })
                        
                        if budget_items_display:
                            items_df = pd.DataFrame(budget_items_display)
                            # フォーマット処理
                            items_df_display = items_df.copy()
                            items_df_display['予算額'] = items_df_display['予算額'].apply(format_currency)
                            
                            # AgGrid設定
                            gb = GridOptionsBuilder.from_dataframe(items_df_display)
                            gb.configure_default_column(
                                groupable=False,
                                value=True,
                                enableRowGroup=False,
                                editable=False,
                                resizable=True
                            )
                            gb.configure_column('ID', width=80)
                            gb.configure_column('項目名', width=150)
                            gb.configure_column('予算額', width=120, cellStyle={'textAlign': 'right'})
                            gb.configure_column('説明', width=250)
                            
                            gridOptions = gb.build()
                            
                            AgGrid(
                                items_df_display,
                                gridOptions=gridOptions,
                                data_return_mode=DataReturnMode.AS_INPUT,
                                update_mode=GridUpdateMode.MODEL_CHANGED,
                                fit_columns_on_grid_load=True,
                                theme='alpine',
                                height=200,
                                width='100%'
                            )
                    
                    # 予算項目用CSVダウンロード・アップロード機能
                    st.markdown("---")
                    with st.expander("💾 予算項目CSV管理", expanded=False):
                        st.info(f"💡 {grant['name']} の予算項目をCSVファイルでダウンロード・アップロードできます")
                        
                        # ダウンロード機能
                        st.markdown("**📥 予算項目のダウンロード**")
                        if grant.get('budget_items'):
                            # 現在の予算項目をCSV形式で準備
                            budget_items_data = []
                            for item in grant['budget_items']:
                                budget_items_data.append({
                                    'budget_item_id': item.get('id', ''),
                                    'budget_item_name': item['name'],
                                    'budget_item_budget': item['budget'],
                                    'budget_item_description': item.get('description', '')
                                })
                            
                            df_budget_items = pd.DataFrame(budget_items_data)
                            csv_budget_items = '\ufeff' + df_budget_items.to_csv(index=False, encoding=None)  # BOM付きUTF-8
                            
                            col_download, col_info = st.columns([1, 2])
                            with col_download:
                                st.download_button(
                                    label="📥 予算項目CSVダウンロード",
                                    data=csv_budget_items,
                                    file_name=f"{grant['name']}_予算項目_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                                    mime="text/csv; charset=utf-8",
                                    key=f"download_budget_items_{grant['id']}",
                                    help="現在の予算項目をCSV形式でダウンロード"
                                )
                            with col_info:
                                st.info(f"📊 現在の予算項目数: {len(budget_items_data)}件")
                        else:
                            st.warning("予算項目がありません。まず予算項目を登録してください。")
                        
                        st.markdown("---")
                        
                        # アップロード機能
                        st.markdown("**📤 予算項目のアップロード**")
                        
                        # 予算項目用CSVのサンプルを表示
                        st.markdown("**📋 CSVフォーマット例:**")
                        sample_csv = """budget_item_id,budget_item_name,budget_item_budget,budget_item_description
1,人件費,100000,スタッフ給与
2,事務費,50000,事務用品等
3,消耗品費,30000,清掃用品等"""
                        st.code(sample_csv, language="csv")
                        
                        budget_items_file = st.file_uploader(
                            "予算項目CSVファイルを選択",
                            type=['csv'],
                            key=f"budget_items_upload_{grant['id']}",
                            help="予算項目の情報のみを含むCSVファイルをアップロードしてください"
                        )
                        
                        if budget_items_file is not None:
                            col_replace, col_append = st.columns(2)
                            
                            with col_replace:
                                if st.button("🔄 予算項目を置換", key=f"replace_budget_items_{grant['id']}", type="primary"):
                                    try:
                                        # CSVファイルを読み込み
                                        csv_content = budget_items_file.read().decode('utf-8-sig')
                                        import io
                                        df = pd.read_csv(io.StringIO(csv_content))
                                        
                                        # 予算項目データを解析
                                        new_budget_items = []
                                        for _, row in df.iterrows():
                                            # 予算額からカンマを削除してから変換
                                            budget_amount = 0
                                            if pd.notna(row['budget_item_budget']):
                                                budget_str = str(row['budget_item_budget']).replace(',', '').replace('¥', '').strip()
                                                try:
                                                    budget_amount = int(float(budget_str))
                                                except (ValueError, TypeError):
                                                    budget_amount = 0
                                            
                                            new_budget_items.append({
                                                'id': str(row['budget_item_id']) if pd.notna(row['budget_item_id']) else str(len(new_budget_items) + 1),
                                                'name': str(row['budget_item_name']) if pd.notna(row['budget_item_name']) else '',
                                                'budget': budget_amount,
                                                'description': str(row['budget_item_description']) if pd.notna(row['budget_item_description']) else ''
                                            })
                                        
                                        # 助成金の予算項目を更新
                                        for g in st.session_state.grants:
                                            if g['id'] == grant['id']:
                                                g['budget_items'] = new_budget_items
                                                # 総予算額を自動計算
                                                g['total_budget'] = sum(item['budget'] for item in new_budget_items)
                                                break
                                        
                                        # 保存
                                        save_grants_to_csv(st.session_state.grants)
                                        st.success(f"✅ {grant['name']} の予算項目を {len(new_budget_items)} 件で置換しました")
                                        st.rerun()
                                        
                                    except Exception as e:
                                        st.error(f"❌ インポートエラー: {str(e)}")
                                        st.info("CSVファイルの形式を確認してください")
                            
                            with col_append:
                                if st.button("➕ 予算項目を追加", key=f"append_budget_items_{grant['id']}"):
                                    try:
                                        # CSVファイルを読み込み
                                        csv_content = budget_items_file.read().decode('utf-8-sig')
                                        import io
                                        df = pd.read_csv(io.StringIO(csv_content))
                                        
                                        # 既存の予算項目IDの最大値を取得
                                        existing_ids = [int(item.get('id', 0)) for item in grant.get('budget_items', [])]
                                        max_id = max(existing_ids, default=0)
                                        
                                        # 予算項目データを解析
                                        new_budget_items = []
                                        for _, row in df.iterrows():
                                            # 予算額からカンマを削除してから変換
                                            budget_amount = 0
                                            if pd.notna(row['budget_item_budget']):
                                                budget_str = str(row['budget_item_budget']).replace(',', '').replace('¥', '').strip()
                                                try:
                                                    budget_amount = int(float(budget_str))
                                                except (ValueError, TypeError):
                                                    budget_amount = 0
                                            
                                            max_id += 1
                                            new_budget_items.append({
                                                'id': str(max_id),
                                                'name': str(row['budget_item_name']) if pd.notna(row['budget_item_name']) else '',
                                                'budget': budget_amount,
                                                'description': str(row['budget_item_description']) if pd.notna(row['budget_item_description']) else ''
                                            })
                                        
                                        # 助成金の予算項目に追加
                                        for g in st.session_state.grants:
                                            if g['id'] == grant['id']:
                                                g['budget_items'].extend(new_budget_items)
                                                # 総予算額を自動計算
                                                g['total_budget'] = sum(item['budget'] for item in g['budget_items'])
                                                break
                                        
                                        # 保存
                                        save_grants_to_csv(st.session_state.grants)
                                        st.success(f"✅ {grant['name']} に予算項目を {len(new_budget_items)} 件追加しました")
                                        st.rerun()
                                        
                                    except Exception as e:
                                        st.error(f"❌ インポートエラー: {str(e)}")
                                        st.info("CSVファイルの形式を確認してください")
    else:
        st.info("まだ助成金が登録されていません。上記のフォームから新規登録してください。")

def show_allocation_page():
    """取引割り当てページ（完全版）"""
    st.header("🔗 取引の助成金割り当て")
    
    if st.session_state.transactions.empty:
        st.warning("取引データがありません。まずfreeeデータをアップロードしてください。")
        return
    
    if not st.session_state.grants:
        st.warning("助成金が登録されていません。まず助成金を登録してください。")
        return
    
    st.markdown("---")
    
    # スマートフィルター・並べ替え機能
    st.subheader("🔍 スマートフィルター・並べ替え設定")
    
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
    
    # クイックフィルター
    st.markdown("**⚡ クイックフィルター**")
    quick_filter_col1, quick_filter_col2, quick_filter_col3 = st.columns(3)
    
    with quick_filter_col1:
        if st.button("📅 今月の取引"):
            current_month = pd.Timestamp.now().to_period('M')
            st.session_state['quick_filter_month'] = current_month
            st.rerun()
    
    with quick_filter_col2:
        if st.button("🔄 未割り当て取引"):
            st.session_state['quick_filter_unallocated'] = True
            st.rerun()
    
    with quick_filter_col3:
        if st.button("✅ 割り当て済み取引"):
            st.session_state['quick_filter_allocated'] = True
            st.rerun()
    
    # クリアボタン
    if st.button("🔄 フィルターをクリア"):
        for key in ['quick_filter_month', 'quick_filter_unallocated', 'quick_filter_allocated']:
            if key in st.session_state:
                del st.session_state[key]
        st.rerun()
    
    # クイックフィルターの適用
    if st.session_state.get('quick_filter_month'):
        if '取引日' in transactions_filtered.columns:
            try:
                transactions_filtered['取引日'] = pd.to_datetime(transactions_filtered['取引日'], errors='coerce')
                current_month = st.session_state['quick_filter_month']
                month_mask = transactions_filtered['取引日'].dt.to_period('M') == current_month
                transactions_filtered = transactions_filtered[month_mask]
                st.info(f"📅 {current_month}の取引でフィルター中")
            except:
                st.warning("取引日の処理でエラーが発生しました")
    
    if st.session_state.get('quick_filter_unallocated'):
        # 未割り当て取引のフィルター
        unallocated_mask = []
        for idx, row in transactions_filtered.iterrows():
            trans_id = f"{row['仕訳番号']}_{row['仕訳行番号']}"
            is_allocated = trans_id in st.session_state.allocations
            unallocated_mask.append(not is_allocated)
        transactions_filtered = transactions_filtered[unallocated_mask]
        st.info("🔄 未割り当て取引でフィルター中")
    
    if st.session_state.get('quick_filter_allocated'):
        # 割り当て済み取引のフィルター
        allocated_mask = []
        for idx, row in transactions_filtered.iterrows():
            trans_id = f"{row['仕訳番号']}_{row['仕訳行番号']}"
            is_allocated = trans_id in st.session_state.allocations
            allocated_mask.append(is_allocated)
        transactions_filtered = transactions_filtered[allocated_mask]
        st.info("✅ 割り当て済み取引でフィルター中")
    
    st.markdown("---")
    
    # 詳細フィルター設定（折りたたみ式）
    with st.expander("🔧 詳細フィルター設定", expanded=False):
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
    
        # 並べ替え設定（詳細フィルター内）
        st.markdown("**📊 並べ替え設定**")
        
        # クイック並べ替えボタン
        quick_sort_col1, quick_sort_col2, quick_sort_col3 = st.columns(3)
        with quick_sort_col1:
            if st.button("📅 取引日順"):
                st.session_state['quick_sort'] = ('取引日', True)
                st.rerun()
        with quick_sort_col2:
            if st.button("💰 金額順"):
                st.session_state['quick_sort'] = ('借方金額', False)
                st.rerun()
        with quick_sort_col3:
            if st.button("🏢 部門順"):
                st.session_state['quick_sort'] = ('借方部門', True)
                st.rerun()
        
        # 詳細並べ替え設定
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
    
    # クイック並べ替えの適用
    if st.session_state.get('quick_sort'):
        sort_col, sort_asc = st.session_state['quick_sort']
        if sort_col in transactions_filtered.columns:
            try:
                if sort_col == '借方金額':
                    transactions_filtered[sort_col] = pd.to_numeric(transactions_filtered[sort_col], errors='coerce')
                elif sort_col == '取引日':
                    transactions_filtered[sort_col] = pd.to_datetime(transactions_filtered[sort_col], errors='coerce')
                
                transactions_filtered = transactions_filtered.sort_values(by=[sort_col], ascending=[sort_asc])
                st.info(f"📊 {sort_col}で並べ替え中 ({'昇順' if sort_asc else '降順'})")
            except:
                st.warning("並べ替えの処理でエラーが発生しました")
    else:
        # 詳細並べ替え実行
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
    
    st.subheader("📝 取引割り当て（直接編集対応版）")
    st.info("💡 「現在の割り当て」列で直接予算項目を変更できます")
    st.info(f"📊 表示件数: {len(transactions_filtered)}件")
    
    # 予算項目選択肢を準備
    budget_options = ["未割り当て"]
    budget_item_map = {}
    
    for grant in st.session_state.grants:
        if grant.get('budget_items'):
            for item in grant['budget_items']:
                option_text = f"{grant['name']} - {item['name']} ({format_currency(item['budget'])})"
                budget_options.append(option_text)
                budget_item_map[option_text] = {
                    'grant_name': grant['name'],
                    'item_id': item.get('id', f"GRANT{grant['id']}_{item['name']}")
                }
    
    # フィルター済みデータを使用して表形式で表示
    if not transactions_filtered.empty:
        display_data = []
        
        for idx, row in transactions_filtered.iterrows():
            trans_id = f"{row['仕訳番号']}_{row['仕訳行番号']}"
            
            # 現在の割り当て状況を取得
            current_alloc = st.session_state.allocations.get(trans_id, {})
            current_selection = "未割り当て"
            
            if isinstance(current_alloc, dict) and current_alloc.get('budget_item_id'):
                # 予算項目IDから選択肢テキストを逆引き
                for option_text, info in budget_item_map.items():
                    if info['item_id'] == current_alloc['budget_item_id']:
                        current_selection = option_text
                        break
            
            # 取引金額の処理
            trans_amount = 0
            if '借方金額' in row:
                try:
                    trans_amount = float(row['借方金額'])
                except (ValueError, TypeError):
                    trans_amount = 0
            
            # 取引日の処理
            transaction_date = ''
            if pd.notna(row.get('取引日', '')):
                try:
                    date_obj = pd.to_datetime(row['取引日'])
                    transaction_date = date_obj.strftime('%Y-%m-%d')
                except:
                    transaction_date = str(row.get('取引日', ''))
            
            # データ行を構築
            row_data = {
                '現在の割り当て': current_selection,
                '取引日': transaction_date,
                '借方部門': str(row.get('借方部門', '')) if pd.notna(row.get('借方部門', '')) else '',
                '借方勘定科目': str(row.get('借方勘定科目', '')) if pd.notna(row.get('借方勘定科目', '')) else '',
                '借方金額': format_currency(trans_amount),
                '借方取引先名': str(row.get('借方取引先名', '')) if pd.notna(row.get('借方取引先名', '')) else '',
                '借方備考': str(row.get('借方備考', '')) if pd.notna(row.get('借方備考', '')) else '',
                '取引ID': trans_id
            }
            display_data.append(row_data)
        
        if display_data:
            # AgGridで高機能な表を表示
            display_df = pd.DataFrame(display_data)
            
            # AgGridの設定
            gb = GridOptionsBuilder.from_dataframe(display_df)
            
            # 基本設定
            gb.configure_default_column(
                groupable=False,
                value=True,
                enableRowGroup=False,
                editable=False,
                resizable=True,
                sortable=True,
                filter=True
            )
            
            # 「現在の割り当て」列を編集可能なセレクトボックスに設定
            gb.configure_column(
                "現在の割り当て",
                editable=True,
                cellEditor="agSelectCellEditor",
                cellEditorParams={"values": budget_options},
                width=300,
                pinned="left"  # 左側に固定
            )
            
            # 金額列の右揃え設定
            gb.configure_column(
                "借方金額", 
                cellStyle={'textAlign': 'right'},
                width=120
            )
            
            # その他の列の設定
            gb.configure_column("取引日", width=100)
            gb.configure_column("借方部門", width=120)
            gb.configure_column("借方勘定科目", width=200)
            gb.configure_column("借方取引先名", width=180)
            gb.configure_column("借方備考", width=200)
            gb.configure_column("取引ID", width=120, pinned="right")
            
            # グリッドオプション
            gb.configure_pagination(paginationAutoPageSize=True)
            gb.configure_side_bar()
            gb.configure_selection('single')  # 単一行選択
            
            # カスタムCSS: 割り当て状況による行の色分け
            rowClassRules = {
                "allocation-assigned": "params.data['現在の割り当て'] !== '未割り当て'",
                "allocation-unassigned": "params.data['現在の割り当て'] === '未割り当て'"
            }
            gb.configure_grid_options(rowClassRules=rowClassRules)
            
            gridOptions = gb.build()
            
            # カスタムCSS
            st.markdown("""
            <style>
            .ag-theme-alpine .ag-row.allocation-assigned {
                background-color: #d4edda !important;
            }
            .ag-theme-alpine .ag-row.allocation-unassigned {
                background-color: #fff3cd !important;
            }
            .ag-theme-alpine .ag-cell {
                font-size: 13px !important;
            }
            </style>
            """, unsafe_allow_html=True)
            
            # AgGrid表示
            st.markdown("**📋 取引一覧（直接編集対応）**")
            st.info("💡 「現在の割り当て」列をクリックして予算項目を選択・変更できます")
            
            grid_response = AgGrid(
                display_df,
                gridOptions=gridOptions,
                data_return_mode=DataReturnMode.FILTERED_AND_SORTED,
                update_mode=GridUpdateMode.VALUE_CHANGED,
                fit_columns_on_grid_load=True,
                theme='alpine',
                height=600,
                width='100%',
                allow_unsafe_jscode=True,
                key="allocation_aggrid"
            )
            
            # 編集があった場合の処理
            if grid_response and grid_response['data'] is not None:
                edited_df = pd.DataFrame(grid_response['data'])
                
                # 自動保存（編集があった場合）
                if not edited_df.equals(display_df):
                    updated_count = 0
                    
                    # 変更を検出して保存
                    for i, (_, new_row) in enumerate(edited_df.iterrows()):
                        if i < len(display_data):
                            original_allocation = display_data[i]['現在の割り当て']
                            new_allocation = new_row['現在の割り当て']
                            trans_id = new_row['取引ID']
                            
                            if original_allocation != new_allocation:
                                # 取引金額を取得
                                for _, orig_row in transactions_filtered.iterrows():
                                    if f"{orig_row['仕訳番号']}_{orig_row['仕訳行番号']}" == trans_id:
                                        try:
                                            trans_amount = float(orig_row['借方金額'])
                                        except (ValueError, TypeError):
                                            trans_amount = 0
                                        break
                                else:
                                    trans_amount = 0
                                
                                if new_allocation == "未割り当て":
                                    # 割り当て解除
                                    if trans_id in st.session_state.allocations:
                                        del st.session_state.allocations[trans_id]
                                        updated_count += 1
                                else:
                                    # 新しい割り当て
                                    if new_allocation in budget_item_map:
                                        budget_info = budget_item_map[new_allocation]
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
                        st.success(f"✅ {updated_count}件の割り当てを自動保存しました")
                        # リロードせずに状態を更新
                        st.session_state.allocation_last_update = datetime.now()
            
            # 手動保存ボタン
            col1, col2 = st.columns([3, 1])
            with col2:
                if st.button("🔄 表示更新", type="secondary", use_container_width=True):
                    st.rerun()
            

        else:
            st.info("表示する取引データがありません")
            
        # 割り当て状況サマリー
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
                                    "予算額": format_currency(item['budget']),
                                    "割り当て額": format_currency(allocated_amount),
                                    "残額": format_currency(remaining_amount),
                                    "取引数": transaction_count,
                                    "執行率": format_percentage(execution_rate)
                                })
                
                if summary_display_data:
                    st.markdown("**現在の割り当て状況:**")
                    summary_df = pd.DataFrame(summary_display_data)
                    
                    # AgGridでサマリー表示（金額右揃え）
                    gb = GridOptionsBuilder.from_dataframe(summary_df)
                    gb.configure_default_column(
                        groupable=True,
                        value=True,
                        enableRowGroup=True,
                        editable=False,
                        resizable=True
                    )
                    
                    # 金額列の右揃え設定
                    gb.configure_column('予算額', cellStyle={'textAlign': 'right'})
                    gb.configure_column('割り当て額', cellStyle={'textAlign': 'right'})
                    gb.configure_column('残額', cellStyle={'textAlign': 'right'})
                    gb.configure_column('執行率', cellStyle={'textAlign': 'right'})
                    gb.configure_column('取引数', cellStyle={'textAlign': 'right'})
                    
                    gb.configure_pagination(paginationAutoPageSize=True)
                    
                    gridOptions = gb.build()
                    
                    AgGrid(
                        summary_df,
                        gridOptions=gridOptions,
                        data_return_mode=DataReturnMode.AS_INPUT,
                        update_mode=GridUpdateMode.MODEL_CHANGED,
                        fit_columns_on_grid_load=True,
                        theme='alpine',
                        height=300,
                        width='100%'
                    )
                    
                    # 簡易統計
                    total_transactions = sum([data['取引数'] for data in summary_display_data])
                    st.info(f"💡 現在 {len(summary_display_data)} 個の予算項目に {total_transactions} 件の取引が割り当てられています")
                else:
                    st.info("表示できる割り当て状況がありません")
            else:
                st.info("割り当てデータがありません")
        else:
            st.info("まだ取引の割り当てがありません。")
    else:
        st.error("取引データがありません")

def show_bulk_allocation_page():
    """一括割り当てページ（完全版）"""
    st.header("🎯 一括取引割り当て")
    
    # データの状態チェック（早期リターンを削除）
    has_transactions = not st.session_state.transactions.empty
    has_grants = bool(st.session_state.grants)
    
    # 【事】【管】で始まる取引のみフィルタリング（事前処理）
    transactions_filtered = pd.DataFrame()
    if has_transactions:
        transactions_filtered = st.session_state.transactions.copy()
        if '借方勘定科目' in transactions_filtered.columns:
            mask = transactions_filtered['借方勘定科目'].astype(str).str.startswith(('【事】', '【管】'))
            transactions_filtered = transactions_filtered[mask]
    
    has_filtered_transactions = not transactions_filtered.empty
        
    # 🏗️ 左右2列レイアウト
    col_left, col_right = st.columns([1, 3])  # 左1:右3の比率（取引一覧を広く）
    
    # CSS スタイル定義
    st.markdown("""
    <style>
    .compact-info { 
        line-height: 1.2; 
        margin-bottom: 0.2rem;
    }
    /* 取引一覧AgGridのスタイル調整 */
    .ag-theme-alpine {
        font-size: 10px !important;
    }
    .ag-theme-alpine .ag-row {
        height: 18px !important;
        min-height: 18px !important;
    }
    .ag-theme-alpine .ag-cell {
        padding: 0px 2px !important;
        line-height: 1.0 !important;
        vertical-align: middle !important;
    }
    .ag-theme-alpine .ag-header-cell {
        padding: 0px 2px !important;
        font-size: 9px !important;
        height: 20px !important;
        line-height: 1.0 !important;
    }
    .ag-theme-alpine .ag-header-row {
        height: 20px !important;
    }
    /* 取引一覧の特定の列にさらに細かい調整 */
    .ag-theme-alpine .ag-cell-value {
        font-size: 10px !important;
        line-height: 1.0 !important;
    }
    /* チェックボックス列の調整 */
    .ag-theme-alpine .ag-selection-checkbox {
        margin: 0 !important;
        padding: 0 !important;
        transform: scale(0.8);
    }
    </style>
    """, unsafe_allow_html=True)
    
    with col_left:
        # 🎯 左列：シンプルな予算項目選択
        st.subheader("🎯 予算項目選択")
        
        # データ状態の警告表示
        if not has_transactions:
            st.warning("📋 取引データがありません。まずfreeeデータをアップロードしてください。")
        elif not has_filtered_transactions:
            st.warning("【事】【管】で始まる取引データがありません。")
        
        if not has_grants:
            st.warning("助成金が登録されていません。割り当て操作を行うには、まず助成金を登録してください。")
        
        # 第1段階：助成金ドロップダウン選択
        grant_options = ["選択してください"]
        grant_map = {}
        
        if has_grants:
            for grant in st.session_state.grants:
                grant_options.append(grant['name'])
                grant_map[grant['name']] = grant
        
        selected_grant_name = st.selectbox(
            "1️⃣ 助成金を選択してください",
            options=grant_options,
            key="simple_grant_select",
            disabled=not has_grants
        )
        
        # 選択された助成金を取得
        selected_grant = None
        grant_has_budget_items = False
        
        if has_grants and selected_grant_name != "選択してください":
            selected_grant = grant_map[selected_grant_name]
            grant_has_budget_items = bool(selected_grant.get('budget_items'))
            
            if not grant_has_budget_items:
                st.warning("選択された助成金には予算項目が設定されていません。")
        
        if selected_grant_name == "選択してください":
            st.info("👆 上記から助成金を選択してください")
        
        # 第2段階：予算項目一覧表（単一選択）
        st.markdown("**2️⃣ 予算項目を選択してください**")
        
        # 予算項目データを準備
        budget_items_data = []
        if has_grants and selected_grant and grant_has_budget_items:
            for item in selected_grant['budget_items']:
                item_id = item.get('id', f"GRANT{selected_grant['id']}_{item['name']}")
                
                # 現在の割り当て状況を計算
                allocated_amount = 0
                allocated_count = 0
                for trans_id, allocation in st.session_state.allocations.items():
                    if isinstance(allocation, dict) and allocation.get('budget_item_id') == item_id:
                        allocated_amount += allocation.get('amount', 0)
                        allocated_count += 1
                
                remaining_amount = item['budget'] - allocated_amount
                execution_rate = (allocated_amount / item['budget'] * 100) if item['budget'] > 0 else 0
                
                budget_items_data.append({
                    '予算項目': item['name'],
                    '説明': item.get('description', ''),
                    '予算額': item['budget'],
                    '割当額': allocated_amount,
                    '残額': remaining_amount,
                    '執行率': execution_rate,
                    '取引数': allocated_count,
                    'grant_info': selected_grant,
                    'item_info': item,
                    'item_id': item_id
                })
        
        # AgGridで予算項目一覧を表示（単一選択）
        if budget_items_data:
            budget_items_df = pd.DataFrame(budget_items_data)
            # 表示用のデータを作成（予算項目名と残額のみ）
            display_budget_df = budget_items_df[['予算項目', '残額']].copy()
        else:
            # 空のDataFrameを作成
            display_budget_df = pd.DataFrame(columns=['予算項目', '残額'])
        
        # AgGridの設定
        gb_budget = GridOptionsBuilder.from_dataframe(display_budget_df)
        
        # 基本設定
        gb_budget.configure_default_column(
            groupable=False,
            value=True,
            enableRowGroup=False,
            editable=False,
            resizable=True,
            sortable=True,
            filter=False
        )
        
        # 単一行選択
        gb_budget.configure_selection(
            'single',
            use_checkbox=True,
            pre_selected_rows=[]
        )
        
        # 列の設定（予算項目名と残額のみ）
        gb_budget.configure_column("予算項目", width=200)
        gb_budget.configure_column(
            "残額", 
            width=120,
            cellStyle={'textAlign': 'right'},
            valueFormatter="'¥' + value.toLocaleString()"
        )
        
        gb_budget.configure_pagination(paginationAutoPageSize=False, paginationPageSize=10)
        
        gridOptions_budget = gb_budget.build()
        
        budget_grid_response = AgGrid(
            display_budget_df,
            gridOptions=gridOptions_budget,
            data_return_mode=DataReturnMode.AS_INPUT,
            update_mode=GridUpdateMode.SELECTION_CHANGED,
            fit_columns_on_grid_load=True,
            theme='alpine',
            height=300,
            width='100%',
            allow_unsafe_jscode=True,
            key="simple_budget_items_aggrid"
        )
        
        # 選択された予算項目を取得（単一選択）
        selected_budget_item = None
        selected_budget_index = None
        
        if budget_grid_response and 'selected_rows' in budget_grid_response and budget_items_data:
            selected_rows = budget_grid_response['selected_rows']
            if selected_rows is not None and len(selected_rows) > 0:
                # AgGridから返されるデータの型によって処理を分ける
                if isinstance(selected_rows, pd.DataFrame):
                    # DataFrameの場合、インデックスを取得して元データから情報を取得
                    if not selected_rows.empty:
                        # 選択された行のインデックスを取得
                        raw_index = selected_rows.index[0]
                        try:
                            selected_budget_index = int(raw_index)
                            if 0 <= selected_budget_index < len(budget_items_data):
                                selected_budget_item = budget_items_data[selected_budget_index].copy()
                                # 助成金情報を追加
                                selected_budget_item['助成金'] = selected_grant['name']
                        except (ValueError, TypeError):
                            # インデックスが数値でない場合、予算項目名で検索
                            for i, item in enumerate(budget_items_data):
                                if str(item.get('予算項目', '')) == str(raw_index):
                                    selected_budget_item = budget_items_data[i].copy()
                                    selected_budget_item['助成金'] = selected_grant['name']
                                    selected_budget_index = i
                                    break
                elif isinstance(selected_rows, list):
                    # リストの場合、最初の要素のインデックスで予算項目を取得
                    idx = selected_rows[0]
                    if isinstance(idx, int) and 0 <= idx < len(budget_items_data):
                        selected_budget_item = budget_items_data[idx].copy()
                        selected_budget_item['助成金'] = selected_grant['name']
                        selected_budget_index = idx
                    elif isinstance(idx, dict):
                        # 辞書の場合、インデックスを特定して元データを取得
                        for i, item in enumerate(budget_items_data):
                            if item['予算項目'] == idx.get('予算項目'):
                                selected_budget_item = budget_items_data[i].copy()
                                selected_budget_item['助成金'] = selected_grant['name']
                                selected_budget_index = i
                                break
        
        # 予算項目が選択されているかチェック（選択されていなくても取引一覧は表示）
        budget_item_selected = selected_budget_item is not None
        
        if not budget_item_selected:
            st.info("👆 上記の一覧から予算項目を1つ選択すると、詳細情報と一括割り当てが可能になります")
        
        if budget_item_selected:
            # 選択された予算項目の詳細情報を表示
            st.markdown("---")
            st.markdown("**✅ 選択中の予算項目**")
            
            st.markdown(f'<div class="compact-info"><strong>予算項目：</strong> {selected_budget_item.get("予算項目", "")}</div>', unsafe_allow_html=True)
            st.markdown(f'<div class="compact-info"><strong>説明：</strong> {selected_budget_item.get("説明", "なし")}</div>', unsafe_allow_html=True)
            st.markdown(f'<div class="compact-info"><strong>予算額：</strong> {format_currency(selected_budget_item.get("予算額", 0))}</div>', unsafe_allow_html=True)
            st.markdown(f'<div class="compact-info"><strong>割当額：</strong> {format_currency(selected_budget_item.get("割当額", 0))}</div>', unsafe_allow_html=True)
            st.markdown(f'<div class="compact-info"><strong>残額：</strong> {format_currency(selected_budget_item.get("残額", 0))}</div>', unsafe_allow_html=True)
            st.markdown(f'<div class="compact-info"><strong>執行率：</strong> {format_percentage(selected_budget_item.get("執行率", 0))}</div>', unsafe_allow_html=True)
            
            # 既存割り当て取引一覧の表示
            st.markdown("---")
            st.markdown("**📋 既存割り当て取引一覧**")
            
            # この予算項目に割り当てられた取引を表示
            allocated_transactions = []
            for trans_id, allocation in st.session_state.allocations.items():
                if isinstance(allocation, dict) and allocation.get('budget_item_id') == selected_budget_item.get('item_id', selected_budget_item.get('予算項目ID', '')):
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
                                amount = allocation.get('amount', 0)
                                
                                # 取引日の処理
                                transaction_date = ''
                                if pd.notna(row.get('取引日', '')):
                                    try:
                                        date_obj = pd.to_datetime(row['取引日'])
                                        transaction_date = date_obj.strftime('%Y-%m-%d')
                                    except:
                                        transaction_date = str(row.get('取引日', ''))
                                
                                allocated_transactions.append({
                                    '取引日': transaction_date,
                                    '借方勘定科目': str(row.get('借方勘定科目', '')),
                                    '借方金額': amount,
                                    '借方取引先名': str(row.get('借方取引先名', '')),
                                    '取引ID': trans_id,
                                })
            
            if allocated_transactions:
                st.dataframe(
                    pd.DataFrame(allocated_transactions),
                    use_container_width=True,
                    column_config={
                        "取引日": st.column_config.TextColumn("取引日", width="small"),
                        "借方勘定科目": st.column_config.TextColumn("借方勘定科目", width="medium"),
                        "借方金額": st.column_config.NumberColumn("借方金額", width="small", format="¥%d"),
                        "借方取引先名": st.column_config.TextColumn("借方取引先名", width="medium"),
                        "取引ID": st.column_config.TextColumn("取引ID", width="small"),
                    },
                    hide_index=True
                )
                
                st.info(f"💡 現在{len(allocated_transactions)}件の取引が割り当て済みです")
            else:
                st.info("まだ取引が割り当てられていません")
    
    with col_right:
        # 📋 右列：取引一覧と一括割り当て
        st.subheader("📋 取引一覧（全件表示）")
        
        # 全ての取引を表示（割り当て状況含む）
        all_transaction_data = []
        
        if has_filtered_transactions:
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
                    '割り当て状況': allocated_info if is_allocated else "⚪ 未割り当て",
                    '取引日': transaction_date,
                    '借方部門': str(row.get('借方部門', '')),
                    '借方勘定科目': str(row.get('借方勘定科目', '')),
                    '借方金額': int(amount) if amount > 0 else 0,
                    '借方取引先名': str(row.get('借方取引先名', '')),
                    '借方備考': str(row.get('借方備考', '')),
                    '取引ID': trans_id,  # 一番右に移動
                })
        
        # 取引一覧を常に表示
        # 金額範囲を事前に計算
        amounts = [d['借方金額'] for d in all_transaction_data if d['借方金額'] > 0] if all_transaction_data else []
        
        # 📊 フィルター・並べ替え設定UI（アコーディオン式）
        with st.expander("📊 フィルター・並べ替え設定", expanded=False):
            filter_col1, filter_col2, filter_col3 = st.columns(3)
            
            with filter_col1:
                st.markdown("**フィルター条件**")
                
                # 取引日フィルター
                available_dates = [d['取引日'] for d in all_transaction_data if d['取引日']]
                if available_dates:
                    # 日付を解析して最小・最大値を取得
                    parsed_dates = []
                    for date_str in available_dates:
                        try:
                            parsed_dates.append(pd.to_datetime(date_str).date())
                        except:
                            continue
                    
                    if parsed_dates:
                        min_date = min(parsed_dates)
                        max_date = max(parsed_dates)
                        
                        date_range = st.date_input(
                            "取引日範囲",
                            value=(min_date, max_date),
                            min_value=min_date,
                            max_value=max_date,
                            key="bulk_date_filter",
                            help="取引日の範囲を選択してください"
                        )
                    else:
                        date_range = None
                else:
                    date_range = None
                
                # 部門フィルター
                available_departments = sorted(list(set([d['借方部門'] for d in all_transaction_data if d['借方部門']])))
                selected_departments = st.multiselect("借方部門", available_departments, key="bulk_dept_filter")
                
                # 勘定科目フィルター
                available_accounts = sorted(list(set([d['借方勘定科目'] for d in all_transaction_data if d['借方勘定科目']])))
                selected_accounts = st.multiselect("借方勘定科目", available_accounts, key="bulk_account_filter")
            
            with filter_col2:
                st.markdown("**金額範囲**")
                if amounts:
                    min_amount, max_amount = min(amounts), max(amounts)
                    amount_range = st.slider(
                        "借方金額範囲",
                        min_value=int(min_amount),
                        max_value=int(max_amount),
                        value=(int(min_amount), int(max_amount)),
                        key="bulk_amount_filter"
                    )
                else:
                    amount_range = (0, 0)
                
                # 割り当て状況フィルター
                allocation_status = st.selectbox(
                    "割り当て状況",
                    ["全て", "未割り当てのみ", "割り当て済みのみ"],
                    key="bulk_allocation_filter"
                )
            
            with filter_col3:
                st.markdown("**並べ替え・表示設定**")
                sort_columns = ["取引日", "借方部門", "借方勘定科目", "借方金額", "借方取引先名", "取引ID"]
                
                sort_col1 = st.selectbox("第1並べ替え", ["なし"] + sort_columns, key="bulk_sort1")
                sort_order1 = st.selectbox("順序", ["昇順", "降順"], key="bulk_order1") if sort_col1 != "なし" else "昇順"
                
                sort_col2 = st.selectbox("第2並べ替え", ["なし"] + sort_columns, key="bulk_sort2")
                sort_order2 = st.selectbox("順序 ", ["昇順", "降順"], key="bulk_order2") if sort_col2 != "なし" else "昇順"
                
                # 一覧の高さ設定
                st.markdown("**一覧表示高さ**")
                table_height = st.slider(
                    "高さ（ピクセル）",
                    min_value=300,
                    max_value=1200,
                    value=600,
                    step=50,
                    key="bulk_table_height",
                    help="一覧表の表示高さを調整できます"
                )
            
            # フィルター・並べ替え条件をリセットボタン
            st.markdown("---")
            if st.button("🔄 フィルター・並べ替え条件をリセット", use_container_width=True):
                # セッション状態のキーをクリア
                keys_to_clear = ["bulk_date_filter", "bulk_dept_filter", "bulk_account_filter", "bulk_amount_filter", 
                               "bulk_allocation_filter", "bulk_sort1", "bulk_order1", "bulk_sort2", "bulk_order2", "bulk_table_height"]
                for key in keys_to_clear:
                    if key in st.session_state:
                        del st.session_state[key]
                st.rerun()
        
        # セッション状態からフィルター条件を取得
        date_range = st.session_state.get("bulk_date_filter", None)
        selected_departments = st.session_state.get("bulk_dept_filter", [])
        selected_accounts = st.session_state.get("bulk_account_filter", [])
        amount_range = st.session_state.get("bulk_amount_filter", (min(amounts), max(amounts)) if amounts else (0, 0))
        allocation_status = st.session_state.get("bulk_allocation_filter", "全て")
        sort_col1 = st.session_state.get("bulk_sort1", "なし")
        sort_order1 = st.session_state.get("bulk_order1", "昇順")
        sort_col2 = st.session_state.get("bulk_sort2", "なし")
        sort_order2 = st.session_state.get("bulk_order2", "昇順")
        table_height = st.session_state.get("bulk_table_height", 600)
        
        # フィルター適用状況を表示
        filter_status = []
        if selected_departments:
            filter_status.append(f"部門: {len(selected_departments)}件選択")
        if selected_accounts:
            filter_status.append(f"勘定科目: {len(selected_accounts)}件選択")
        if amounts and (amount_range[0] != min(amounts) or amount_range[1] != max(amounts)):
            filter_status.append(f"金額: {format_currency(amount_range[0])} - {format_currency(amount_range[1])}")
        if allocation_status != "全て":
            filter_status.append(f"割当状況: {allocation_status}")
        if sort_col1 != "なし":
            sort_status = f"並べ替え: {sort_col1} ({sort_order1})"
            if sort_col2 != "なし":
                sort_status += f" → {sort_col2} ({sort_order2})"
            filter_status.append(sort_status)
        
        if filter_status:
            st.info(f"🔍 適用中の条件: {' | '.join(filter_status)}")
        
        # フィルター適用
        filtered_data = all_transaction_data.copy() if all_transaction_data else []
        
        # データがある場合のみフィルター適用
        if filtered_data:
            # 取引日フィルター適用
            if date_range and len(date_range) == 2:
                start_date, end_date = date_range
                filtered_data = [d for d in filtered_data 
                               if d['取引日'] and start_date <= pd.to_datetime(d['取引日']).date() <= end_date]
            
            # 部門フィルター適用
            if selected_departments:
                filtered_data = [d for d in filtered_data if d['借方部門'] in selected_departments]
            
            # 勘定科目フィルター適用
            if selected_accounts:
                filtered_data = [d for d in filtered_data if d['借方勘定科目'] in selected_accounts]
            
            # 金額フィルター適用
            if amounts:
                filtered_data = [d for d in filtered_data if amount_range[0] <= d['借方金額'] <= amount_range[1]]
            
            # 割り当て状況フィルター適用
            if allocation_status == "未割り当てのみ":
                filtered_data = [d for d in filtered_data if d['割り当て状況'].startswith('⚪')]
            elif allocation_status == "割り当て済みのみ":
                filtered_data = [d for d in filtered_data if d['割り当て状況'].startswith('✅')]
            
            # 並べ替え適用
            if sort_col1 != "なし":
                reverse1 = sort_order1 == "降順"
                if sort_col2 != "なし":
                    reverse2 = sort_order2 == "降順"
                    # 第2、第1の順で並べ替え（最終的に第1が優先される）
                    filtered_data = sorted(filtered_data, key=lambda x: x[sort_col2], reverse=reverse2)
                    filtered_data = sorted(filtered_data, key=lambda x: x[sort_col1], reverse=reverse1)
                else:
                    filtered_data = sorted(filtered_data, key=lambda x: x[sort_col1], reverse=reverse1)
        
        # AgGridで高機能な表を表示（行選択機能付き・データがない場合は空の表）
        if filtered_data:
            display_df = pd.DataFrame(filtered_data)
        else:
            # 空のDataFrameを作成（列構造を保持）
            display_df = pd.DataFrame(columns=[
                '割り当て状況', '取引日', '借方部門', '借方勘定科目', '借方金額', '借方取引先名', '借方備考', '取引ID'
            ])
        
        # AgGridの設定
        gb = GridOptionsBuilder.from_dataframe(display_df)
        
        # 基本設定
        gb.configure_default_column(
            groupable=False,
            value=True,
            enableRowGroup=False,
            editable=False,
            resizable=True,
            sortable=True,
            filter=True
        )
        
        # 行選択機能（チェックボックス）
        gb.configure_selection(
            'multiple',  # 複数行選択
            use_checkbox=True,  # チェックボックス使用
            header_checkbox=True,  # ヘッダーに全選択チェックボックス
            pre_selected_rows=[]  # 初期選択行なし
        )
        
        # 列の設定
        gb.configure_column("割り当て状況", width=250, pinned="left")
        gb.configure_column("取引日", width=130)  # 日付がすべて表示されるように幅を拡張
        gb.configure_column("借方部門", width=120) 
        gb.configure_column("借方勘定科目", width=200)
        gb.configure_column(
            "借方金額", 
            width=120,
            cellStyle={'textAlign': 'right'},
            type=["numericColumn", "numberColumnFilter", "customNumericFormat"],
            valueFormatter="'¥' + value.toLocaleString()"
        )
        gb.configure_column("借方取引先名", width=180)
        gb.configure_column("借方備考", width=200)
        gb.configure_column("取引ID", width=120)
        
        # 選択された予算項目に応じた行の色分け
        rowClassRules = {}
        if budget_item_selected:
            selected_item_id = selected_budget_item.get('item_id', '')
            selected_grant_name = selected_budget_item.get('助成金', '')
            selected_budget_name = selected_budget_item.get('予算項目', '')
            target_text = f"✅ {selected_grant_name} - {selected_budget_name}"
            
            rowClassRules = {
                "selected-budget-item": f"params.data['割り当て状況'] === '{target_text}'",
                "allocation-assigned": "params.data['割り当て状況'].includes('✅') && params.data['割り当て状況'] !== '" + target_text + "'",
                "allocation-unassigned": "params.data['割り当て状況'].includes('⚪')"
            }
        else:
            rowClassRules = {
                "allocation-assigned": "params.data['割り当て状況'].includes('✅')",
                "allocation-unassigned": "params.data['割り当て状況'].includes('⚪')"
            }
        
        gb.configure_grid_options(rowClassRules=rowClassRules)
        
        # ページング設定（pagesize指定）
        gb.configure_pagination(paginationAutoPageSize=False, paginationPageSize=50)
        gb.configure_side_bar()
        
        gridOptions = gb.build()
        
        # カスタムCSS（文字サイズ縮小・色分け強化）
        st.markdown("""
        <style>
        .ag-theme-alpine .ag-row.selected-budget-item {
            background-color: #e7f3ff !important;
            border: 2px solid #007bff !important;
            font-weight: bold !important;
        }
        .ag-theme-alpine .ag-row.allocation-assigned {
            background-color: #d4edda !important;
        }
        .ag-theme-alpine .ag-row.allocation-unassigned {
            background-color: #fff3cd !important;
        }
        .ag-theme-alpine .ag-cell {
            font-size: 11px !important;
            padding: 4px 6px !important;
        }
        .ag-theme-alpine .ag-header-cell-text {
            font-size: 12px !important;
            font-weight: bold !important;
        }
        .ag-theme-alpine .ag-checkbox-input {
            accent-color: #1f77b4 !important;
        }
        .compact-info {
            line-height: 1.2 !important;
            margin: 2px 0 !important;
            font-size: 14px !important;
        }
        </style>
        """, unsafe_allow_html=True)
        

        
        # 選択取引合計金額用のプレースホルダ
        selection_amount_placeholder = st.empty()
        
        grid_response = AgGrid(
            display_df,
            gridOptions=gridOptions,
            data_return_mode=DataReturnMode.AS_INPUT,
            update_mode=GridUpdateMode.SELECTION_CHANGED,
            fit_columns_on_grid_load=True,
            theme='alpine',
            height=table_height,
            width='100%',
            allow_unsafe_jscode=True,
            key="bulk_transaction_aggrid"
        )
        
        # 選択された行を取得（複数選択対応）
        selected_rows = []
        if grid_response and 'selected_rows' in grid_response:
            selected_data = grid_response['selected_rows']
            if selected_data is not None and len(selected_data) > 0:
                # AgGridから返されるデータの型によって処理を分ける
                if isinstance(selected_data, pd.DataFrame):
                    # DataFrameの場合、各行を辞書に変換して取得
                    for _, row in selected_data.iterrows():
                        selected_rows.append(row.to_dict())
                elif isinstance(selected_data, list):
                    # リストの場合、各要素を確認
                    for item in selected_data:
                        if isinstance(item, int) and 0 <= item < len(filtered_data):
                            # インデックスの場合、フィルター済みデータから取得
                            selected_rows.append(filtered_data[item])
                        elif isinstance(item, dict):
                            # 辞書の場合、そのまま使用
                            selected_rows.append(item)
        
        selected_count = len(selected_rows)
        
        # 選択取引合計金額の表示（統計情報の直後のプレースホルダに表示）
        if selected_count > 0:
            try:
                total_amount = sum([row['借方金額'] for row in selected_rows if isinstance(row, dict) and '借方金額' in row])
                
                # 選択された取引の統計
                selected_allocated = len([row for row in selected_rows if isinstance(row, dict) and row.get('割り当て状況', '').startswith('✅')])
                selected_unallocated = selected_count - selected_allocated
                
                # プレースホルダにシンプルな合計金額表示
                with selection_amount_placeholder.container():
                    st.info(f"💰 選択取引合計金額: {format_currency(total_amount)} （✅ 割当済み: {selected_allocated}件 | ⚪ 未割当: {selected_unallocated}件）")
                
            except Exception as e:
                with selection_amount_placeholder.container():
                    st.error(f"合計金額計算エラー: {str(e)}")
        else:
            # 選択がない場合はプレースホルダを空にしておく（何も表示しない）
            selection_amount_placeholder.empty()
        
        # 🎯 一括割り当て操作
        st.markdown("---")
        col1, col2 = st.columns([2, 1])
        
        with col1:
            if selected_count > 0:
                st.success(f"🎯 **{selected_count}件の取引を選択中 - 一括割り当ての準備ができています**")
                st.info("右側のボタンで選択した取引を一括で予算項目に割り当てできます。")
            else:
                st.info("💡 取引を選択すると、ここに一括割り当ての操作が表示されます。")
        
        with col2:
            # 🎯 一括割り当て部分
            if selected_count > 0 and budget_item_selected:
                # 選択された予算項目への一括割り当て
                grant_name = selected_budget_item.get('助成金', '')
                budget_item_name = selected_budget_item.get('予算項目', '')
                target_name = f"{grant_name} - {budget_item_name}"
                
                if st.button(f"🎯 選択した{selected_count}件を「{target_name}」に一括割り当て", type="primary", use_container_width=True):
                    assigned_count = 0
                    
                    try:
                        # 予算項目の詳細情報を取得
                        grant_name = selected_budget_item.get('助成金', '')
                        budget_item_id = selected_budget_item.get('item_id', selected_budget_item.get('予算項目ID', ''))
                        
                        if not grant_name or not budget_item_id:
                            st.error("❌ 助成金名または予算項目IDが取得できません。予算項目を再選択してください。")
                            return
                        
                        for row in selected_rows:
                            # 取引データから安全にアクセス
                            if isinstance(row, dict) and '取引ID' in row and '借方金額' in row:
                                trans_id = row['取引ID']
                                trans_amount = row['借方金額']
                                
                                st.session_state.allocations[trans_id] = {
                                    'grant_name': grant_name,
                                    'budget_item_id': budget_item_id,
                                    'amount': trans_amount,
                                    'transaction_amount': trans_amount
                                }
                                assigned_count += 1
                        
                        if assigned_count > 0:
                            # ファイルに保存
                            save_allocations_to_csv(st.session_state.allocations)
                            
                            # 保存後にファイルから再読み込みして同期を確保
                            reloaded_allocations = load_allocations_from_csv()
                            st.session_state.allocations = reloaded_allocations
                            
                            final_count = len(st.session_state.allocations)
                            st.success(f"✅ {assigned_count}件の取引を「{target_name}」に割り当て、ファイルに保存しました！（現在の割り当て数: {final_count}件）")
                            st.rerun()
                        else:
                            st.warning("⚠️ 割り当てできる取引がありませんでした。")
                    except Exception as e:
                        st.error(f"一括割り当て処理エラー: {str(e)}")
            
            # 🗑️ 一括解除ボタン（予算項目選択に依存せず独立して表示）
            if selected_count > 0:
                st.markdown("---")
                
                # 選択された取引のうち割り当て済みの件数を確認
                selected_allocated_count = 0
                for row in selected_rows:
                    if isinstance(row, dict) and row.get('割り当て状況', '').startswith('✅'):
                        selected_allocated_count += 1
                
                if selected_allocated_count > 0:
                    if st.button(f"🗑️ 選択した{selected_allocated_count}件の割り当てを一括解除", 
                                type="secondary", 
                                use_container_width=True,
                                help="選択した取引のうち、割り当て済みの取引の割り当てを一括で解除します"):
                        removed_count = 0
                        
                        try:
                            for row in selected_rows:
                                if isinstance(row, dict) and '取引ID' in row:
                                    trans_id = row['取引ID']
                                    # 割り当て済みの取引のみ解除
                                    if trans_id in st.session_state.allocations:
                                        del st.session_state.allocations[trans_id]
                                        removed_count += 1
                            
                            if removed_count > 0:
                                # デバッグ用：解除前後の件数確認
                                remaining_count = len(st.session_state.allocations)
                                st.info(f"🔍 デバッグ: {removed_count}件解除後、残り{remaining_count}件")
                                
                                # ファイルに保存
                                try:
                                    save_allocations_to_csv(st.session_state.allocations)
                                    
                                    # 保存後にファイルから再読み込みして同期を確保
                                    reloaded_allocations = load_allocations_from_csv()
                                    st.session_state.allocations = reloaded_allocations
                                    
                                    final_count = len(st.session_state.allocations)
                                    st.success(f"✅ {removed_count}件の取引割り当てを解除し、ファイルに保存しました！（現在の割り当て数: {final_count}件）")
                                except Exception as save_error:
                                    st.error(f"❌ 保存エラー: {str(save_error)}")
                                st.rerun()
                            else:
                                st.warning("⚠️ 解除できる割り当てがありませんでした。")
                        except Exception as e:
                            st.error(f"一括解除処理エラー: {str(e)}")
                else:
                    st.info("💡 選択された取引に割り当て済みのものがないため、解除する対象がありません。")
            
            # 無効状態のボタン表示
            if selected_count == 0:
                st.button("🎯 取引を選択してください", disabled=True, use_container_width=True)
            elif not budget_item_selected:
                st.button("🎯 予算項目を選択してください", disabled=True, use_container_width=True)

def show_data_download_page():
    st.header("💾 データダウンロード")
    st.markdown("各種データのダウンロード・アップロード・管理を一括で行えます。")
    
    # ダウンロード機能
    st.subheader("📥 データダウンロード")
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("**💰 助成金データ**")
        
        if st.session_state.grants:
            # 通常形式ダウンロード
            grants_data = []
            for grant in st.session_state.grants:
                budget_items_str = "; ".join([
                    f"{item.get('id', 'NO_ID')}:{item['name']}:¥{item['budget']:,}:{item.get('description', '')}" 
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
            # 日本語環境での文字化け対策（Excel対応優先）
            try:
                # BOM付きUTF-8でCSVを生成
                csv_string = df_grants.to_csv(index=False, encoding=None)
                csv_grants = '\ufeff' + csv_string
                mime_type = "text/csv; charset=utf-8"
            except Exception as e:
                # フォールバック：Shift_JIS
                csv_grants = df_grants.to_csv(index=False, encoding='shift_jis', errors='ignore')
                mime_type = "text/csv; charset=shift_jis"
            
            download_col1, download_col2 = st.columns(2)
            
            with download_col1:
                st.download_button(
                    label="📥 通常形式",
                    data=csv_grants,
                    file_name=f"grants_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                    mime=mime_type,
                    key="download_grants",
                    help="現在の内部形式（budget_items列）"
                )
            
            with download_col2:
                # Excel編集用縦展開形式
                csv_vertical = export_grants_vertical_format(st.session_state.grants)
                st.download_button(
                    label="📊 Excel編集用",
                    data=csv_vertical,
                    file_name=f"grants_excel_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                    mime="text/csv; charset=utf-8",
                    key="download_grants_vertical",
                    help="Excel編集しやすい縦展開形式"
                )
        else:
            st.info("ダウンロードできるデータがありません")
            
        st.info(f"現在登録数: {len(st.session_state.grants)}件")
    
    with col2:
        st.markdown("**🔗 割り当てデータ**")
        
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
            # 日本語環境での文字化け対策（Excel対応優先）
            try:
                # BOM付きUTF-8でCSVを生成
                csv_string = df_allocations.to_csv(index=False, encoding=None)  # まず文字列として生成
                csv_allocations = '\ufeff' + csv_string  # BOMを手動で追加
                mime_type = "text/csv; charset=utf-8"
            except Exception as e:
                # フォールバック：Shift_JIS
                csv_allocations = df_allocations.to_csv(index=False, encoding='shift_jis', errors='ignore')
                mime_type = "text/csv; charset=shift_jis"
            
            st.download_button(
                label="📥 CSVダウンロード",
                data=csv_allocations,
                file_name=f"allocations_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                mime=mime_type,
                key="download_allocations"
            )
        else:
            st.info("ダウンロードできるデータがありません")
            
        st.info(f"現在割り当て数: {len(st.session_state.allocations)}件")
    
    with col3:
        st.markdown("**📊 取引データ**")
        
        if not st.session_state.transactions.empty:
            # 日本語環境での文字化け対策（Excel対応優先）
            try:
                # BOM付きUTF-8でCSVを生成
                csv_string = st.session_state.transactions.to_csv(index=False, encoding=None)  # まず文字列として生成
                csv_data = '\ufeff' + csv_string  # BOMを手動で追加
                mime_type = "text/csv; charset=utf-8"
            except Exception as e:
                # フォールバック：Shift_JIS
                csv_data = st.session_state.transactions.to_csv(index=False, encoding='shift_jis', errors='ignore')
                mime_type = "text/csv; charset=shift_jis"
            
            st.download_button(
                label="📥 CSVダウンロード",
                data=csv_data,
                file_name=f"transactions_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                mime=mime_type,
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
        
        upload_format = st.radio(
            "アップロード形式を選択:",
            ["通常形式", "Excel編集用（縦展開）"],
            key="upload_format_grants",
            horizontal=True
        )
        
        grants_file = st.file_uploader(
            "助成金データCSVファイル", 
            type=['csv'], 
            key="grants_upload",
            help="選択した形式に対応するCSVファイルをアップロードしてください"
        )
        
        if grants_file is not None:
            if st.button("🔄 助成金データを更新", type="primary", key="update_grants"):
                try:
                    if upload_format == "Excel編集用（縦展開）":
                        # 縦展開形式から読み込み
                        csv_content = grants_file.read().decode('utf-8-sig')
                        st.session_state.grants = import_grants_vertical_format(csv_content)
                        st.success("✅ Excel編集用データが正常にインポートされました")
                    else:
                        # 通常形式から読み込み
                        st.session_state.grants = load_grants_from_csv()
                        st.success("✅ 通常形式データが正常にインポートされました")
                    st.rerun()
                except Exception as e:
                    st.error(f"❌ インポートエラー: {str(e)}")
                    st.info("ファイル形式を確認してください")
    
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

def export_grants_vertical_format(grants: list) -> str:
    """助成金データを縦展開形式でエクスポートする（Excel編集用）"""
    if not grants:
        return ""
    
    # 縦展開データを準備
    vertical_data = []
    for grant in grants:
        # 基本情報（Excel編集用は最小限）
        base_info = {
            'id': grant['id'],
            'name': grant['name']
        }
        
        # 予算項目がある場合は各項目を1行ずつ
        if grant.get('budget_items'):
            for item in grant['budget_items']:
                row = base_info.copy()
                row.update({
                    'budget_item_id': item.get('id', ''),
                    'budget_item_name': item['name'],
                    'budget_item_budget': item['budget'],
                    'budget_item_description': item.get('description', '')
                })
                vertical_data.append(row)
        else:
            # 予算項目がない場合は空行を追加
            row = base_info.copy()
            row.update({
                'budget_item_id': '',
                'budget_item_name': '',
                'budget_item_budget': 0,
                'budget_item_description': ''
            })
            vertical_data.append(row)
    
    # DataFrameに変換してCSV文字列を生成
    df = pd.DataFrame(vertical_data)
    csv_string = df.to_csv(index=False, encoding=None)
    return '\ufeff' + csv_string  # BOM付きUTF-8

def import_grants_vertical_format(csv_content: str) -> list:
    """縦展開形式のCSVから助成金データを復元する"""
    import io
    
    # CSVを読み込み
    df = pd.read_csv(io.StringIO(csv_content))
    
    grants = []
    grants_dict = {}
    
    for _, row in df.iterrows():
        grant_id = int(row['id'])
        
        # 助成金の基本情報を取得または作成
        if grant_id not in grants_dict:
            grants_dict[grant_id] = {
                'id': grant_id,
                'name': row['name'],
                'source': '',  # Excel編集用では入力されないのでデフォルト値
                'start_date': '2025-01-01',  # Excel編集用では入力されないのでデフォルト値
                'end_date': '2025-12-31',  # Excel編集用では入力されないのでデフォルト値  
                'description': '',  # Excel編集用では入力されないのでデフォルト値
                'created_at': datetime.now().strftime('%Y-%m-%dT%H:%M:%S.%f'),  # 現在時刻をデフォルト値
                'budget_items': []
            }
        
        # 予算項目を追加（空でない場合）
        budget_item_name = row['budget_item_name']
        if budget_item_name is not None and str(budget_item_name).strip():
            budget_item_id = row['budget_item_id']
            budget_item_budget = row['budget_item_budget']
            budget_item_description = row['budget_item_description']
            
            # 予算額からカンマを削除してから変換
            budget_amount = 0
            if budget_item_budget is not None:
                budget_str = str(budget_item_budget).replace(',', '').replace('¥', '').strip()
                try:
                    budget_amount = int(float(budget_str))  # float経由で小数点も対応
                except (ValueError, TypeError):
                    budget_amount = 0
            
            budget_item = {
                'id': str(budget_item_id) if budget_item_id is not None else f"GRANT{grant_id}_ITEM{len(grants_dict[grant_id]['budget_items'])+1}",
                'name': str(budget_item_name),
                'budget': budget_amount,
                'description': str(budget_item_description) if budget_item_description is not None else ''
            }
            grants_dict[grant_id]['budget_items'].append(budget_item)
    
    # total_budgetを自動計算
    for grant in grants_dict.values():
        total = sum(item['budget'] for item in grant['budget_items'])
        grant['total_budget'] = total
        grants.append(grant)
    
    return sorted(grants, key=lambda x: x['id'])

def main():
    """メイン関数"""
    initialize_session_state()
    
    st.title("💰 NPO法人ながいく - 助成金管理システム（AgGrid版）")
    st.markdown("---")
    
    # サイドバーに現在の状況を表示
    st.sidebar.markdown("### 📊 システム状況")
    st.sidebar.write(f"**助成金数**: {len(st.session_state.grants)}件")
    st.sidebar.write(f"**取引数**: {len(st.session_state.transactions)}件")
    st.sidebar.write(f"**割り当て数**: {len(st.session_state.allocations)}件")
    st.sidebar.markdown("---")
    
    # サイドバーでページを選択
    page = st.sidebar.radio(
        "📋 ページを選択",
        ["🏠 ダッシュボード", "📤 データアップロード", "💼 助成金管理", "🔗 取引割り当て", "📊 一括割り当て", "💾 データダウンロード"],
        key="page_selector"
    )
    
    # 各ページの表示
    if page == "🏠 ダッシュボード":
        show_dashboard()
    elif page == "📤 データアップロード":
        show_upload_page()
    elif page == "💼 助成金管理":
        show_grant_management()
    elif page == "🔗 取引割り当て":
        show_allocation_page()
    elif page == "📊 一括割り当て":
        show_bulk_allocation_page()
    elif page == "💾 データダウンロード":
        show_data_download_page()
    
    # フッター
    st.sidebar.markdown("---")
    st.sidebar.markdown("**AgGrid版** - 改良された表示・編集機能")

if __name__ == "__main__":
    main() 