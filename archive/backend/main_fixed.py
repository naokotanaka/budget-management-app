@app.post("/api/import/allocations")
async def import_allocations(file: UploadFile = File(...)):
    """割当データをCSVからインポート（完全生SQL版）"""
    print("=== STARTING ALLOCATION IMPORT (RAW SQL) ===")
    # 新しいセッションを作成してバッチ処理を無効化
    from database import engine
    from sqlalchemy.orm import sessionmaker
    
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
    
    try:
        print("=== READING FILE ===")
        # ファイル内容を読み取り
        contents = await file.read()
        
        # 文字エンコーディングを検出
        detected = chardet.detect(contents)
        encoding = detected['encoding'] or 'utf-8'
        
        # CSVデータを解析
        text_data = contents.decode(encoding)
        
        # BOMを削除
        if text_data.startswith('\ufeff'):
            text_data = text_data[1:]
        
        lines = text_data.strip().split('\n')
        reader = csv.reader(lines)
        
        # ヘッダー行をスキップ
        next(reader, None)
        
        import_stats = {
            'allocations_created': 0,
            'allocations_updated': 0,
            'errors': []
        }
        
        print(f"=== PROCESSING ROWS ===")
        # 割当データのインポート
        for row_num, row in enumerate(reader, 1):
            if len(row) < 3:
                continue
            try:
                print(f"Row {row_num}: {row}")
                # CSVの構造: ID(空), 取引ID, 予算項目ID, 金額
                if len(row) >= 4:
                    allocation_id, transaction_id, budget_item_id, amount = row[:4]
                else:
                    # ID列がない場合
                    allocation_id = ""
                    transaction_id, budget_item_id, amount = row[:3]
                
                print(f"Parsed: ID={allocation_id}, TxID={transaction_id}, BudgetID={budget_item_id}, Amount={amount}")
                
                # 既存の割当を確認（IDが空欄でない場合のみ）- 生SQLで実行
                existing_allocation_id = None
                if allocation_id and str(allocation_id).strip():
                    try:
                        result = db.execute(text("SELECT id FROM allocations WHERE id = :id"), {"id": int(allocation_id)}).fetchone()
                        if result:
                            existing_allocation_id = result[0]
                            print(f"Found existing allocation: {existing_allocation_id}")
                    except ValueError:
                        import_stats['errors'].append(f"割当ID {allocation_id}: 無効なIDです")
                        continue
                
                # 取引と予算項目の存在確認 - 生SQLで実行
                transaction_check = db.execute(text("SELECT id FROM transactions WHERE id = :id"), {"id": transaction_id}).fetchone()
                budget_item_check = db.execute(text("SELECT id FROM budget_items WHERE id = :id"), {"id": int(budget_item_id)}).fetchone()
                
                if not transaction_check:
                    import_stats['errors'].append(f"取引ID {transaction_id} が見つかりません")
                    continue
                
                if not budget_item_check:
                    import_stats['errors'].append(f"予算項目ID {budget_item_id} が見つかりません")
                    continue
                
                # 空文字列や無効な値をチェック
                if not amount or str(amount).strip() == '':
                    import_stats['errors'].append(f"割当ID {allocation_id}: 金額が空です")
                    continue
                
                try:
                    # 金額フィールドのクリーニング
                    amount_str = str(amount).strip()
                    # カンマ、円マーク、円文字を削除
                    amount_str = amount_str.replace(',', '').replace('¥', '').replace('円', '')
                    # 前後の空白を再度削除
                    amount_str = amount_str.strip()
                    # データベースのamount列はInteger型なので、intに変換
                    amount_value = int(float(amount_str))
                    print(f"Amount converted: {amount} -> {amount_str} -> {amount_value}")
                except (ValueError, TypeError) as e:
                    import_stats['errors'].append(f"割当ID {allocation_id}: 金額が無効です ({amount}) - {str(e)}")
                    print(f"Amount conversion error: {amount} - {str(e)}")
                    continue
                
                # 完全生SQLで処理
                if existing_allocation_id:
                    # 更新
                    try:
                        print(f"Updating allocation {existing_allocation_id}")
                        db.execute(
                            text("UPDATE allocations SET transaction_id = :transaction_id, budget_item_id = :budget_item_id, amount = :amount WHERE id = :id"),
                            {
                                "transaction_id": transaction_id,
                                "budget_item_id": int(budget_item_id),
                                "amount": amount_value,
                                "id": existing_allocation_id
                            }
                        )
                        db.commit()
                        import_stats['allocations_updated'] += 1
                        print(f"Update successful: ID={existing_allocation_id}")
                    except Exception as update_error:
                        print(f"Update error: {str(update_error)}")
                        import_stats['errors'].append(f"割当ID {allocation_id}: 更新エラー - {str(update_error)}")
                        db.rollback()
                        continue
                else:
                    # 新規作成
                    try:
                        if allocation_id and str(allocation_id).strip():
                            # IDが指定されている場合
                            print(f"Creating with specified ID: {allocation_id}")
                            db.execute(
                                text("INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at) VALUES (:id, :transaction_id, :budget_item_id, :amount, :created_at)"),
                                {
                                    "id": int(allocation_id),
                                    "transaction_id": transaction_id,
                                    "budget_item_id": int(budget_item_id),
                                    "amount": amount_value,
                                    "created_at": datetime.now()
                                }
                            )
                        else:
                            # IDが空欄の場合は自動採番
                            print("Creating with auto ID")
                            max_id_result = db.execute(text("SELECT COALESCE(MAX(id), 0) + 1 FROM allocations")).fetchone()
                            next_id = max_id_result[0] if max_id_result else 1
                            print(f"Next ID: {next_id}")
                            
                            db.execute(
                                text("INSERT INTO allocations (id, transaction_id, budget_item_id, amount, created_at) VALUES (:id, :transaction_id, :budget_item_id, :amount, :created_at)"),
                                {
                                    "id": next_id,
                                    "transaction_id": transaction_id,
                                    "budget_item_id": int(budget_item_id),
                                    "amount": amount_value,
                                    "created_at": datetime.now()
                                }
                            )
                        
                        db.commit()
                        import_stats['allocations_created'] += 1
                        print(f"Create successful")
                    except Exception as create_error:
                        print(f"Create error: {str(create_error)}")
                        import_stats['errors'].append(f"割当ID {allocation_id}: 作成エラー - {str(create_error)}")
                        db.rollback()
                        continue
                    
            except Exception as e:
                print(f"Row processing error: {str(e)}")
                import_stats['errors'].append(f"Row {row_num}: {str(e)}")
                db.rollback()
        
        print(f"=== IMPORT COMPLETE ===")
        print(f"Created: {import_stats['allocations_created']}, Updated: {import_stats['allocations_updated']}, Errors: {len(import_stats['errors'])}")
        
        return {
            "message": "割当データのインポートが完了しました",
            "stats": import_stats
        }
        
    except Exception as e:
        print(f"Fatal error: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=400, detail=f"割当データインポートエラー: {str(e)}")
    finally:
        db.close()