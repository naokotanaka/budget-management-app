const express = require('express');
const cors = require('cors');
const multer = require('multer');
const sqlite3 = require('sqlite3').verbose();
const { parse } = require('csv-parse');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 8000;

// Middleware
app.use(cors());
app.use(express.json());

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });

// Database setup
const dbPath = path.join(__dirname, '..', 'data', 'budget.db');
const db = new sqlite3.Database(dbPath);

// Create tables
db.serialize(() => {
  db.run(`CREATE TABLE IF NOT EXISTS transactions (
    id TEXT PRIMARY KEY,
    journal_number INTEGER,
    journal_line_number INTEGER,
    date DATE NOT NULL,
    description TEXT,
    amount INTEGER NOT NULL,
    account TEXT,
    supplier TEXT,
    item TEXT,
    memo TEXT,
    remark TEXT,
    department TEXT,
    management_number TEXT,
    raw_data TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  db.run(`CREATE TABLE IF NOT EXISTS grants (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    total_amount INTEGER,
    start_date DATE,
    end_date DATE
  )`);

  db.run(`CREATE TABLE IF NOT EXISTS budget_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    grant_id INTEGER,
    name TEXT NOT NULL,
    category TEXT,
    budgeted_amount INTEGER,
    FOREIGN KEY (grant_id) REFERENCES grants(id)
  )`);

  db.run(`CREATE TABLE IF NOT EXISTS allocations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    transaction_id TEXT,
    budget_item_id INTEGER,
    amount INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (budget_item_id) REFERENCES budget_items(id)
  )`);
});

// API Routes

// Get all transactions with allocations
app.get('/api/transactions', (req, res) => {
  const query = `
    SELECT 
      t.*,
      bi.id as budget_item_id,
      bi.name as budget_item_name,
      bi.category as budget_item_category,
      bi.budgeted_amount as budget_item_budgeted_amount,
      bi.grant_id as budget_item_grant_id,
      a.amount as allocated_amount
    FROM transactions t
    LEFT JOIN allocations a ON t.id = a.transaction_id
    LEFT JOIN budget_items bi ON a.budget_item_id = bi.id
    ORDER BY t.date DESC
  `;
  
  db.all(query, (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    
    const transactions = rows.map(row => ({
      id: row.id,
      journal_number: row.journal_number,
      journal_line_number: row.journal_line_number,
      date: row.date,
      description: row.description,
      amount: row.amount,
      account: row.account,
      supplier: row.supplier,
      item: row.item,
      memo: row.memo,
      remark: row.remark,
      department: row.department,
      management_number: row.management_number,
      created_at: row.created_at,
      budget_item: row.budget_item_id ? {
        id: row.budget_item_id,
        name: row.budget_item_name,
        category: row.budget_item_category,
        budgeted_amount: row.budget_item_budgeted_amount,
        grant_id: row.budget_item_grant_id
      } : null,
      allocated_amount: row.allocated_amount
    }));
    
    res.json(transactions);
  });
});

// CSV Preview
app.post('/api/transactions/preview', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  try {
    // Try different encodings for Japanese CSV files
    let csvData;
    try {
      csvData = fs.readFileSync(req.file.path, 'utf8');
    } catch (err) {
      try {
        csvData = fs.readFileSync(req.file.path, 'shift_jis');
      } catch (err2) {
        csvData = fs.readFileSync(req.file.path, 'binary');
      }
    }

    // Clean up the file early to avoid accumulation
    const filePath = req.file.path;
    
    parse(csvData, {
      columns: true,
      skip_empty_lines: true,
      delimiter: ',',
      quote: '"',
      escape: '"',
      relax_quotes: true,
      relax_column_count: true
    }, (err, records) => {
      // Clean up uploaded file
      try {
        fs.unlinkSync(filePath);
      } catch (cleanupErr) {
        console.error('File cleanup error:', cleanupErr);
      }
      
      if (err) {
        console.error('CSV parsing error:', err);
        return res.status(500).json({ 
          error: 'CSV parsing failed', 
          details: err.message,
          hint: 'Please ensure the file is a valid CSV with proper encoding (UTF-8 or Shift-JIS)'
        });
      }

      if (!records || records.length === 0) {
        return res.status(400).json({ error: 'No data found in CSV file' });
      }

      const previewData = [];
      let filteredCount = 0;

      records.forEach((record, index) => {
        try {
          // Filter for transactions starting with 【事】or 【管】
          const debitAccount = record['借方勘定科目'] || '';
          const creditAccount = record['貸方勘定科目'] || '';
          
          if (debitAccount.startsWith('【事】') || debitAccount.startsWith('【管】') ||
              creditAccount.startsWith('【事】') || creditAccount.startsWith('【管】')) {
            
            const account = debitAccount.startsWith('【事】') || debitAccount.startsWith('【管】') 
              ? debitAccount : creditAccount;
            const amount = parseInt(record['借方金額'] || record['貸方金額'] || 0);
            const transactionId = `${record['仕訳番号']}_${record['仕訳行番号']}`;
            
            if (previewData.length < 10) { // Show first 10 rows
              previewData.push({
                id: transactionId,
                date: record['取引日'],
                description: record['取引内容'],
                amount: amount,
                account: account,
                supplier: record['借方取引先名'] || record['貸方取引先名'] || ''
              });
            }
            filteredCount++;
          }
        } catch (recordErr) {
          console.error(`Error processing record ${index}:`, recordErr);
        }
      });

      res.json({
        total_rows: records.length,
        filtered_rows: filteredCount,
        preview: previewData
      });
    });
  } catch (error) {
    // Clean up uploaded file
    try {
      fs.unlinkSync(req.file.path);
    } catch (cleanupErr) {
      console.error('File cleanup error:', cleanupErr);
    }
    
    console.error('File reading error:', error);
    res.status(500).json({ 
      error: 'Failed to read uploaded file', 
      details: error.message 
    });
  }
});

// CSV Import (simplified)
app.post('/api/transactions/import', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  try {
    // Try different encodings for Japanese CSV files
    let csvData;
    try {
      csvData = fs.readFileSync(req.file.path, 'utf8');
    } catch (err) {
      try {
        csvData = fs.readFileSync(req.file.path, 'shift_jis');
      } catch (err2) {
        csvData = fs.readFileSync(req.file.path, 'binary');
      }
    }

    // Clean up the file early to avoid accumulation
    const filePath = req.file.path;
    
    parse(csvData, {
      columns: true,
      skip_empty_lines: true,
      delimiter: ',',
      quote: '"',
      escape: '"',
      relax_quotes: true,
      relax_column_count: true
    }, (err, records) => {
      // Clean up uploaded file
      try {
        fs.unlinkSync(filePath);
      } catch (cleanupErr) {
        console.error('File cleanup error:', cleanupErr);
      }
      
      if (err) {
        console.error('CSV parsing error:', err);
        return res.status(500).json({ 
          error: 'CSV parsing failed', 
          details: err.message,
          hint: 'Please ensure the file is a valid CSV with proper encoding (UTF-8 or Shift-JIS)'
        });
      }

      if (!records || records.length === 0) {
        return res.status(400).json({ error: 'No data found in CSV file' });
      }

      let importedCount = 0;
      const stmt = db.prepare(`
        INSERT OR REPLACE INTO transactions 
        (id, journal_number, journal_line_number, date, description, amount, account, supplier, item, memo, remark, department, management_number, raw_data)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `);

      records.forEach((record, index) => {
        try {
          // Filter for transactions starting with 【事】or 【管】
          const debitAccount = record['借方勘定科目'] || '';
          const creditAccount = record['貸方勘定科目'] || '';
          
          if (debitAccount.startsWith('【事】') || debitAccount.startsWith('【管】') ||
              creditAccount.startsWith('【事】') || creditAccount.startsWith('【管】')) {
            
            const account = debitAccount.startsWith('【事】') || debitAccount.startsWith('【管】') 
              ? debitAccount : creditAccount;
            const amount = parseInt(record['借方金額'] || record['貸方金額'] || 0);
            const transactionId = `${record['仕訳番号']}_${record['仕訳行番号']}`;
            
            stmt.run([
              transactionId,
              parseInt(record['仕訳番号']) || 0,
              parseInt(record['仕訳行番号']) || 0,
              record['取引日'] || '',
              record['取引内容'] || '',
              amount,
              account,
              record['借方取引先名'] || record['貸方取引先名'] || '',
              record['借方品目'] || '',
              record['借方メモ'] || '',
              record['借方備考'] || '',
              record['借方部門'] || '',
              record['管理番号'] || '',
              JSON.stringify(record)
            ]);
            importedCount++;
          }
        } catch (recordErr) {
          console.error(`Error processing record ${index}:`, recordErr);
        }
      });

      stmt.finalize();
      
      res.json({
        message: `${importedCount}件の取引を取り込みました（【事】【管】のみ）`,
        total_checked: records.length,
        imported_count: importedCount
      });
    });
  } catch (error) {
    // Clean up uploaded file
    try {
      fs.unlinkSync(req.file.path);
    } catch (cleanupErr) {
      console.error('File cleanup error:', cleanupErr);
    }
    
    console.error('File reading error:', error);
    res.status(500).json({ 
      error: 'Failed to read uploaded file', 
      details: error.message 
    });
  }
});

// Get all grants
app.get('/api/grants', (req, res) => {
  db.all('SELECT * FROM grants ORDER BY id DESC', (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

// Create grant
app.post('/api/grants', (req, res) => {
  const { name, total_amount, start_date, end_date } = req.body;
  db.run('INSERT INTO grants (name, total_amount, start_date, end_date) VALUES (?, ?, ?, ?)',
    [name, total_amount, start_date, end_date], function(err) {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      res.json({ id: this.lastID, name, total_amount, start_date, end_date });
    });
});

// Get all budget items
app.get('/api/budget-items', (req, res) => {
  db.all('SELECT * FROM budget_items ORDER BY id DESC', (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

// Create budget item
app.post('/api/budget-items', (req, res) => {
  const { name, category, budgeted_amount, grant_id } = req.body;
  db.run('INSERT INTO budget_items (name, category, budgeted_amount, grant_id) VALUES (?, ?, ?, ?)',
    [name, category, budgeted_amount, grant_id], function(err) {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      res.json({ id: this.lastID, name, category, budgeted_amount, grant_id });
    });
});

// Create allocation
app.post('/api/allocations', (req, res) => {
  const { transaction_id, budget_item_id, amount } = req.body;
  
  // Remove existing allocation for this transaction
  db.run('DELETE FROM allocations WHERE transaction_id = ?', [transaction_id], (err) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    
    // Create new allocation
    db.run('INSERT INTO allocations (transaction_id, budget_item_id, amount) VALUES (?, ?, ?)',
      [transaction_id, budget_item_id, amount], function(err) {
        if (err) {
          res.status(500).json({ error: err.message });
          return;
        }
        res.json({ id: this.lastID, transaction_id, budget_item_id, amount });
      });
  });
});

// Batch allocations
app.post('/api/allocations/batch', (req, res) => {
  const allocations = req.body;
  
  db.serialize(() => {
    db.run('BEGIN TRANSACTION');
    
    const stmt = db.prepare('INSERT OR REPLACE INTO allocations (transaction_id, budget_item_id, amount) VALUES (?, ?, ?)');
    
    allocations.forEach(allocation => {
      stmt.run([allocation.transaction_id, allocation.budget_item_id, allocation.amount]);
    });
    
    stmt.finalize();
    db.run('COMMIT');
  });
  
  res.json({ message: `${allocations.length}件の割り当てを作成しました` });
});

// Cross table report
app.get('/api/reports/cross-table', (req, res) => {
  const { start_date, end_date } = req.query;
  
  const query = `
    SELECT 
      bi.name as budget_item,
      strftime('%Y-%m', t.date) as month,
      SUM(a.amount) as total
    FROM allocations a
    JOIN transactions t ON a.transaction_id = t.id
    JOIN budget_items bi ON a.budget_item_id = bi.id
    WHERE t.date BETWEEN ? AND ?
    GROUP BY bi.name, month
  `;
  
  db.all(query, [start_date, end_date], (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    
    const pivotData = {};
    rows.forEach(row => {
      if (!pivotData[row.budget_item]) {
        pivotData[row.budget_item] = {};
      }
      pivotData[row.budget_item][row.month] = row.total;
    });
    
    res.json(pivotData);
  });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'NPO Budget Management API is running' });
});

// Start server
app.listen(port, () => {
  console.log(`🚀 NPO Budget Management API running at http://localhost:${port}`);
  console.log(`📊 Health check: http://localhost:${port}/api/health`);
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🛑 Shutting down server...');
  db.close((err) => {
    if (err) {
      console.error(err.message);
    }
    console.log('✅ Database connection closed.');
    process.exit(0);
  });
});