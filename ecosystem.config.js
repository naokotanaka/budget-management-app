 module.exports = {
    apps: [
      {
        name: 'nagaiku-frontend',
        script: 'npm',
        args: 'start',
        cwd: './frontend',
        env: {
          NODE_ENV: 'production',
          PORT: 3000
        }
      },
      {
        name: 'nagaiku-backend',
        script: 'venv/bin/python',
        args: '-m uvicorn main:app --host 0.0.0.0 --port 8000',
        cwd: './backend',
        interpreter: 'none'
      }
    ]
  };
