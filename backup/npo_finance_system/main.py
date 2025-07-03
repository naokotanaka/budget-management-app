
import streamlit as st
import pandas as pd
import json
from datetime import datetime
import plotly.graph_objects as go
import os

# スクリプトのディレクトリを基準にデータファイルのパスを解決
script_dir = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(script_dir, 'data')

# データファイルのパス
GRANT_BUDGETS_FILE = os.path.join(DATA_DIR, 'grant_budgets.json')
ALLOCATIONS_FILE = os.path.join(DATA_DIR, 'allocations.json')
TRANSACTIONS_FILE = os.path.join(DATA_DIR, 'transactions.csv') # アップロードされたCSVデータの一時保存先

# データの読み込み
def load_data(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return []

# データの保存
def save_data(file_path, data):
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)


def migrate_data_if_needed():
    """
    既存の助成金データに項目ID(item_id)がない場合に自動で付与する移行処理。
    """
    grant_budgets = load_data(GRANT_BUDGETS_FILE)
    needs_saving = False
    for grant in grant_budgets:
        for category in grant.get('categories', []):
            if 'item_id' not in category:
                # 既存の項目にIDを付与
                category['item_id'] = f"G{grant['id']}-{category['id']}"
                needs_saving = True
    
    if needs_saving:
        save_data(GRANT_BUDGETS_FILE, grant_budgets)
        # このメッセージは、更新があった場合のみ次回の実行時に表示される
        st.toast("既存の助成金データを更新し、項目IDを付与しました。")


# 分析・レポートページ
def analysis_report_page():
    st.header("分析・レポート")
    grant_budgets = load_data(GRANT_BUDGETS_FILE)
    allocations = load_data(ALLOCATIONS_FILE)

    st.subheader("割り当て済み仕訳データのエクスポート")
    if st.button("CSVダウンロード"):
        try:
            transactions_df = pd.read_csv(TRANSACTIONS_FILE)
            allocations_df = pd.DataFrame(allocations)

            # 必要なデータのみに絞り、マージする
            merged_df = pd.merge(
                allocations_df, 
                transactions_df, 
                left_on='transaction_unique_id', 
                right_on='unique_id',
                how='left'
            )

            # 助成金名と項目名を追加
            def get_grant_info(row):
                for grant in grant_budgets:
                    if grant['id'] == row['grant_id']:
                        for cat in grant['categories']:
                            if cat['id'] == row['category_id']:
                                return grant['name'], cat['name']
                return None, None

            merged_df[['助成金名', '助成金項目名']] = merged_df.apply(get_grant_info, axis=1, result_type='expand')

            # ダウンロード用に列を整理
            export_df = merged_df[[
                '取引日', '借方勘定科目', '借方金額', '貸方勘定科目', '貸方金額', '摘要',
                '助成金名', '助成金項目名', 'grant_item_id'
            ]]

            csv = export_df.to_csv(index=False).encode('utf-8-sig')
            
            st.download_button(
                label="ダウンロード",
                data=csv,
                file_name='allocated_transactions.csv',
                mime='text/csv',
            )
            st.success("CSVファイルを生成しました。ダウンロードボタンを押してください。")

        except FileNotFoundError:
            st.error("取引データ(transactions.csv)が見つかりません。")
        except Exception as e:
            st.error(f"CSVエクスポート中にエラーが発生しました: {e}")

    page = st.selectbox("表示するレポートを選択", ['年間実績画面', '月別分析画面'])

    if page == '年間実績画面':
        st.subheader("年間実績画面")
        for grant in grant_budgets:
            st.markdown(f"### {grant['name']}")
            
            total_allocated = sum(alloc['amount'] for alloc in allocations if alloc['grant_id'] == grant['id'])
            usage_rate = (total_allocated / grant['total_budget']) if grant['total_budget'] > 0 else 0
            
            st.progress(usage_rate)
            st.metric(label="全体予算", value=f"¥{grant['total_budget']:,}", delta=f"-¥{total_allocated:,} (残り)")

            with st.expander("項目別詳細"):
                for category in grant['categories']:
                    cat_allocated = sum(alloc['amount'] for alloc in allocations if alloc['grant_id'] == grant['id'] and alloc['category_id'] == category['id'])
                    cat_budget = category['total_budget']
                    cat_usage_rate = (cat_allocated / cat_budget) if cat_budget > 0 else 0
                    st.text(f"{category['name']}:")
                    st.progress(cat_usage_rate)
                    st.write(f"予算: ¥{cat_budget:,} / 使用済: ¥{cat_allocated:,}")

    elif page == '月別分析画面':
        st.subheader("月別分析画面")
        
        # 月選択UI
        all_months = sorted(list(set(month for grant in grant_budgets for cat in grant['categories'] for month in cat['monthly_budgets'])))
        selected_month = st.selectbox("月を選択", all_months)

        if selected_month:
            st.markdown(f"#### {selected_month} の予算実績")

            monthly_budget = 0
            monthly_spent = 0
            category_budgets = []
            category_spents = []
            category_names = []

            for grant in grant_budgets:
                for cat in grant['categories']:
                    if selected_month in cat['monthly_budgets']:
                        budget = cat['monthly_budgets'][selected_month]
                        spent = sum(alloc['amount'] for alloc in allocations if alloc['grant_id'] == grant['id'] and alloc['category_id'] == cat['id'] and alloc['transaction_month'] == selected_month)
                        
                        monthly_budget += budget
                        monthly_spent += spent
                        category_budgets.append(budget)
                        category_spents.append(spent)
                        category_names.append(f"{grant['name']}-{cat['name']}")

            st.metric(label="月次予算合計", value=f"¥{monthly_budget:,.0f}", delta=f"-¥{monthly_spent:,.0f} (実績)")

            # グラフ表示
            fig_bar = go.Figure([
                go.Bar(name='予算', x=category_names, y=category_budgets),
                go.Bar(name='実績', x=category_names, y=category_spents)
            ])
            fig_bar.update_layout(title_text='項目別 予算 vs 実績')
            st.plotly_chart(fig_bar, use_container_width=True)

            fig_pie = go.Figure(data=[go.Pie(labels=category_names, values=category_spents, hole=.3)])
            fig_pie.update_layout(title_text='項目別支出割合')
            st.plotly_chart(fig_pie, use_container_width=True)

# 取引割り当てページ
def allocation_page():
    st.header("取引の割り当て")

    # データフレームの選択状態をリセットするためのキー管理
    if "dataframe_key_suffix" not in st.session_state:
        st.session_state.dataframe_key_suffix = 0

    # 必要なデータを読み込む
    grant_budgets = load_data(GRANT_BUDGETS_FILE)
    allocations = load_data(ALLOCATIONS_FILE)
    try:
        transactions_df = pd.read_csv(TRANSACTIONS_FILE)
    except FileNotFoundError:
        st.warning("最初にCSVをアップロードしてください。")
        st.info("デバッグ: transactions.csvが見つからず、処理を中断しました。")
        return

    if not grant_budgets:
        st.warning("最初に助成金を登録してください。")
        st.info("デバッグ: 助成金データが見つからず、処理を中断しました。")
        return

    # 割り当て済み取引IDのリスト
    allocated_transaction_ids = [alloc['transaction_unique_id'] for alloc in allocations]

    # 「借方勘定科目」が「【事】」または「【管】」で始まるものでフィルタリング
    transactions_df = transactions_df[
        transactions_df['借方勘定科目'].str.startswith(('【事】', '【管】'), na=False)
    ]

    # 未割り当ての取引のみ表示
    unallocated_transactions_df = transactions_df[
        ~transactions_df['unique_id'].isin(allocated_transaction_ids)
    ]

    st.subheader("未割り当て取引一覧")

    if unallocated_transactions_df.empty:
        st.info("割り当て可能な取引がありません。")
        return

    st.info("下の表から割り当てる取引を1行クリックして選択してください。")

    # データフレームを表示して行選択を可能にする
    display_df = unallocated_transactions_df.reset_index(drop=True)

    # 表示する列の順番を定義
    priority_columns = [
        '取引日', '借方金額', '借方部門', '借方勘定科目', 
        '借方取引先名', '借方品目', '借方備考', '借方メモ'
    ]
    # 存在する列のみを対象にする
    existing_priority_columns = [col for col in priority_columns if col in display_df.columns]
    other_columns = [col for col in display_df.columns if col not in existing_priority_columns]
    display_df = display_df[existing_priority_columns + other_columns]

    selection = st.dataframe(
        display_df,
        on_select="rerun",
        selection_mode="single-row",
        key=f"transaction_selection_{st.session_state.dataframe_key_suffix}",
        use_container_width=True
    )

    # 選択された行があれば、割り当てフォームを表示
    if selection.selection.rows:
        selected_row_index = selection.selection.rows[0]
        selected_transaction = display_df.iloc[selected_row_index]
        transaction_id = selected_transaction['unique_id']

        st.subheader("選択した取引への割り当て")
        st.write("選択した取引:", selected_transaction)

        if not grant_budgets:
            st.warning("割り当て先の助成金が登録されていません。「助成金予算管理」ページで先に登録してください。")
            return

        grant_id = st.selectbox("助成金を選択", [g['id'] for g in grant_budgets], format_func=lambda g_id: next(g['name'] for g in grant_budgets if g['id'] == g_id), key=f"grant_sel_{transaction_id}")
        selected_grant = next(g for g in grant_budgets if g['id'] == grant_id)

        category_id = st.selectbox("項目を選択", [c['id'] for c in selected_grant['categories']], format_func=lambda c_id: next(c['name'] for c in selected_grant['categories'] if c['id'] == c_id), key=f"cat_sel_{transaction_id}")
        
        amount = st.number_input("割り当て金額", value=float(selected_transaction['借方金額']), key=f"amount_in_{transaction_id}")

        if st.button("割り当て実行", key=f"submit_btn_{transaction_id}"):
            transaction_date = pd.to_datetime(selected_transaction['取引日'])
            start_date = pd.to_datetime(selected_grant['start_month'])
            end_date = pd.to_datetime(selected_grant['end_month']) + pd.offsets.MonthEnd(0)
            selected_category = next((c for c in selected_grant['categories'] if c['id'] == category_id), None)

            if not (start_date <= transaction_date <= end_date):
                st.error("取引日が助成金の使用期間外です。")
            elif selected_category:
                new_allocation = {
                    "allocation_id": len(allocations) + 1,
                    "transaction_unique_id": transaction_id,
                    "grant_id": grant_id,
                    "category_id": category_id,
                    "grant_item_id": selected_category.get('item_id'),
                    "amount": amount,
                    "transaction_month": transaction_date.strftime('%Y-%m')
                }
                allocations.append(new_allocation)
                save_data(ALLOCATIONS_FILE, allocations)
                st.success("割り当てを実行しました。")
                
                # データフレームのキーを変更して再生成させ、選択をリセットする
                st.session_state.dataframe_key_suffix += 1
                st.rerun()
            else:
                st.error("選択された項目が見つかりません。")

# 助成金管理ページ
def grant_management_page():
    st.header("助成金予算管理")

    st.subheader("新規助成金登録")
    
    grant_name = st.text_input("助成金名")
    
    # 使用期間設定
    col1, col2 = st.columns(2)
    with col1:
        start_month_str = st.text_input("開始月 (例: 2025-04)")
    with col2:
        end_month_str = st.text_input("終了月 (例: 2025-08)")

    total_budget = st.number_input("総予算", min_value=0)
    
    # 項目別予算設定
    st.subheader("項目別予算")
    category_names = st.text_area("予算項目を改行で区切って入力 (例: 食材費, 消耗品費)")
    
    categories = []
    if category_names:
        for i, cat_name in enumerate(category_names.strip().split('\n')):
            cat_budget = st.number_input(f"「{cat_name}」の予算", min_value=0, key=f"cat_{i}")
            categories.append({"id": i + 1, "name": cat_name, "total_budget": cat_budget})

    if st.button("助成金を登録"):
        if grant_name and start_month_str and end_month_str and total_budget > 0 and categories:
            try:
                # 月別予算の自動分割
                start_date = datetime.strptime(start_month_str, '%Y-%m')
                end_date = datetime.strptime(end_month_str, '%Y-%m')
                
                month_range = pd.date_range(start=start_date, end=end_date, freq='MS')
                num_months = len(month_range)

                grant_data = load_data(GRANT_BUDGETS_FILE)
                new_grant_id = len(grant_data) + 1

                for category in categories:
                    monthly_budget = category["total_budget"] / num_months
                    category["monthly_budgets"] = {month.strftime('%Y-%m'): monthly_budget for month in month_range}
                    category["item_id"] = f"G{new_grant_id}-{category['id']}"

                # 新しい助成金データを作成
                new_grant = {
                    "id": new_grant_id,
                    "name": grant_name,
                    "start_month": start_month_str,
                    "end_month": end_month_str,
                    "total_budget": total_budget,
                    "categories": categories
                }
                grant_data.append(new_grant)
                save_data(GRANT_BUDGETS_FILE, grant_data)
                st.success("新しい助成金を登録しました。")

            except ValueError:
                st.error("日付の形式が正しくありません。'YYYY-MM'形式で入力してください。")
            except Exception as e:
                st.error(f"エラーが発生しました: {e}")
        else:
            st.warning("すべての項目を正しく入力してください。")

    st.subheader("登録済み助成金一覧")
    st.write(load_data(GRANT_BUDGETS_FILE))

def bulk_allocation_page():
    st.header("一括割り当て")

    # --- データ準備 ---
    # --- データ準備 ---    grant_budgets = load_data(GRANT_BUDGETS_FILE)    allocations = load_data(ALLOCATIONS_FILE)    try:        transactions_df = pd.read_csv(TRANSACTIONS_FILE)    except FileNotFoundError:        st.warning("最初にCSVをアップロードしてください。")        return    if not grant_budgets:        st.warning("最初に助成金を登録してください。")        return    # --- データ加工とマッピング作成 ---    grant_name_map = {g['id']: g['name'] for g in grant_budgets}    category_name_map = {(g['id'], c['id']): c['name'] for g in grant_budgets for c in g.get('categories', [])}        allocations_df = pd.DataFrame(allocations)    if not allocations_df.empty:        allocations_df['alloc_name'] = allocations_df.apply(            lambda row: f"{grant_name_map.get(row['grant_id'])} - {category_name_map.get((row['grant_id'], row['category_id']))}",            axis=1        )    else:        allocations_df['alloc_name'] = ""    filtered_transactions_df = transactions_df[transactions_df['借方勘定科目'].str.startswith(('【事】', '【管】'), na=False)].copy()    if filtered_transactions_df.empty:        st.info("割り当て対象となる取引データがありません。")        return    # --- 表示用データフレームの準備 ---    merged_df = filtered_transactions_df.merge(        allocations_df[['transaction_unique_id', 'grant_item_id', 'alloc_name']],         left_on='unique_id',         right_on='transaction_unique_id',         how='left',         suffixes=('', '_alloc')    )    merged_df['現在の割当'] = merged_df['alloc_name'].fillna('---')    priority_columns = ['現在の割当', '取引日', '借方金額', '借方部門', '借方勘定科目', '借方取引先名', '借方品目', '借方備考', '借方メモ']    display_columns = [col for col in priority_columns if col in merged_df.columns] + [col for col in merged_df.columns if col not in priority_columns]    display_df_bulk = merged_df[display_columns].reset_index(drop=True)    # --- 現在選択中の取引を特定 ---    if "bulk_select_key" not in st.session_state:        st.session_state.bulk_select_key = 0    bulk_df_key = f"bulk_transaction_selection_{st.session_state.bulk_select_key}"        checked_rows_df = pd.DataFrame()    selection_state = st.session_state.get(bulk_df_key)    if selection_state and selection_state["selection"]["rows"]:        selected_indices = selection_state["selection"]["rows"]        checked_rows_df = display_df_bulk.iloc[selected_indices]    # --- 画面レイアウト ---    col1, col2 = st.columns([1, 2])    with col1:        st.markdown("**① 助成金項目を選択**")        initial_spent_by_item = allocations_df.groupby('grant_item_id')['amount'].sum().to_dict() if not allocations_df.empty else {}        # Prepare data for radio buttons        grant_items_data_for_radio = []        for grant in grant_budgets:            for cat in grant.get('categories', []):                item_id = cat.get('item_id')                total_budget = cat.get('total_budget', 0)                spent_amount = initial_spent_by_item.get(item_id, 0)                remaining_budget = total_budget - spent_amount                                start_date = grant.get('start_month', 'N/A')                end_date = grant.get('end_month', 'N/A')                period_str = f"{start_date}～{end_date}"                                grant_items_data_for_radio.append({                    "label_base": f"{grant['name']} - {cat['name']}",                    "grant_id": grant['id'],                    "category_id": cat['id'],                    "item_id": item_id,                    "remaining_budget_initial": remaining_budget,                    "period_str": period_str                })            if not grant_items_data_for_radio:            st.warning("登録されている助成金項目がありません。")            return        # Initialize session state for selected item_id if not present        if "selected_radio_item_id" not in st.session_state:            st.session_state.selected_radio_item_id = grant_items_data_for_radio[0]['item_id'] if grant_items_data_for_radio else None        # Callback function to update selected_radio_item_id        def update_selected_radio_item_id():            # st.session_state.bulk_radio_selection holds the label of the selected item            selected_label_from_radio = st.session_state.bulk_radio_selection            # Find the item_id corresponding to this label            for item_data in grant_items_data_for_radio:                # We need to compare the base label, not the full label with simulation info                if selected_label_from_radio.startswith(item_data['label_base']):                    st.session_state.selected_radio_item_id = item_data['item_id']                    break        # Generate labels for the radio button, applying simulation only to the selected one        radio_labels = []        for item_data in grant_items_data_for_radio:            current_item_id = item_data['item_id']            remaining_budget = item_data['remaining_budget_initial']            period_str = item_data['period_str']            label_base = item_data['label_base']                        final_remaining_budget = remaining_budget # Default to no change            if current_item_id == st.session_state.selected_radio_item_id:                # Apply simulation only to the currently selected item                total_checked_amount = checked_rows_df['借方金額'].sum() if not checked_rows_df.empty else 0                                # Calculate the amount that is currently allocated to this item_id within the checked rows                amount_already_allocated_to_this_item_in_checked_rows = checked_rows_df[                    checked_rows_df['grant_item_id'] == current_item_id                ]['借方金額'].sum()                # The net amount to subtract is the total checked amount minus what's already allocated to this item                net_amount_to_subtract = total_checked_amount - amount_already_allocated_to_this_item_in_checked_rows                                final_remaining_budget = remaining_budget - net_amount_to_subtract                        label = (                f"{label_base}"                f"\n  (期間: {period_str})"                f"\n  (残額: ¥{remaining_budget:,.0f} → **¥{final_remaining_budget:,.0f}**)"            )            radio_labels.append(label)        # Find the index of the currently selected item_id to set the default for st.radio        initial_radio_index = next((i for i, item in enumerate(grant_items_data_for_radio) if item['item_id'] == st.session_state.selected_radio_item_id), 0)        selected_item_label = st.radio(            "割り当てる項目",            radio_labels,            index=initial_radio_index,            key="bulk_radio_selection", # Add a key            on_change=update_selected_radio_item_id # Add a callback        )                # Find the selected_grant_item based on the item_id stored in session state        selected_grant_item = next(item for item in grant_items_data_for_radio if item['item_id'] == st.session_state.selected_radio_item_id)    with col2:        currently_selected_amount = checked_rows_df['借方金額'].sum() if not checked_rows_df.empty else 0        st.markdown(f"**② 割り当てる取引を選択** (現在選択中の合計金額: **¥{currently_selected_amount:,.0f}**)")                def highlight_allocated(row):            return ['background-color: lightblue' if row['現在の割当'] != '---' else '' for _ in row]        st.dataframe(            display_df_bulk.style.apply(highlight_allocated, axis=1),            on_select="rerun",            selection_mode="multi-row",            key=bulk_df_key        )    if st.button("選択した取引に一括割り当てを実行"):        if checked_rows_df.empty:            st.warning("割り当てる取引が選択されていません。")        else:            allocations_dict = {alloc['transaction_unique_id']: alloc for alloc in allocations}            for _, row in checked_rows_df.iterrows():                transaction_id = row['unique_id']                new_alloc = {                    "transaction_unique_id": transaction_id,                    "grant_id": selected_grant_item['grant_id'],                    "category_id": selected_grant_item['category_id'],                    "grant_item_id": selected_grant_item['item_id'],                    "amount": row['借方金額'],                    "transaction_month": pd.to_datetime(row['取引日']).strftime('%Y-%m')                }                if transaction_id in allocations_dict:                    allocations_dict[transaction_id].update(new_alloc)                else:                    new_alloc["allocation_id"] = len(allocations) + 1                    allocations_dict[transaction_id] = new_alloc                        save_data(ALLOCATIONS_FILE, list(allocations_dict.values()))            st.success(f"{len(checked_rows_df)}件の取引に「{selected_item_label.splitlines()[0]}」を割り当てました。")            st.session_state.bulk_select_key += 1            st.rerun()}


# Streamlitアプリのメイン部分
def main():
    st.set_page_config(layout="wide")
    st.title('NPO法人「ながいく」助成金管理システム')

    # アプリケーション起動時にデータ移行処理を実行
    migrate_data_if_needed()

    # サイドバーナビゲーション
    st.sidebar.title('メニュー')
    page = st.sidebar.radio('ページを選択', ['データプレビュー', 'CSVアップロード', '助成金予算管理', '取引の割り当て', '一括割り当て', '分析・レポート'])

    if page == 'データプレビュー':
        st.header('データプレビュー')
        
        st.subheader('助成金データ')
        grant_budgets = load_data(GRANT_BUDGETS_FILE)
        st.write(grant_budgets)

        st.subheader('割り当てデータ')
        allocations = load_data(ALLOCATIONS_FILE)
        st.write(allocations)

    elif page == 'CSVアップロード':
        st.header('freee仕訳データCSVアップロード')
        uploaded_file = st.file_uploader("CSVファイルをアップロードしてください", type=['csv'])
        
        if uploaded_file is not None:
            try:
                df = pd.read_csv(uploaded_file)
                
                # ユニークIDの生成
                df['unique_id'] = df['仕訳番号'].astype(str) + '-' + df['仕訳行番号'].astype(str)
                
                # CSVデータを保存
                os.makedirs(DATA_DIR, exist_ok=True)
                df.to_csv(TRANSACTIONS_FILE, index=False)

                st.success('CSVのアップロードと処理に成功しました。')
                st.subheader('プレビュー')
                st.write(df.head())

            except Exception as e:
                st.error(f"エラーが発生しました: {e}")
    
    elif page == '助成金予算管理':
        grant_management_page()

    elif page == '取引の割り当て':
        allocation_page()

    elif page == '一括割り当て':
        bulk_allocation_page()
    
    elif page == '分析・レポート':
        analysis_report_page()

if __name__ == '__main__':
    main()
