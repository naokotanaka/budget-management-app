import { NextResponse } from 'next/server';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

export async function GET() {
  try {
    // Gitのコミットハッシュを取得
    const { stdout: commitHash } = await execAsync('git rev-parse HEAD');
    const { stdout: commitDate } = await execAsync('git log -1 --format=%ci');
    const { stdout: commitMessage } = await execAsync('git log -1 --format=%s');
    const { stdout: branch } = await execAsync('git rev-parse --abbrev-ref HEAD');

    return NextResponse.json({
      commit: commitHash.trim(),
      commitShort: commitHash.trim().substring(0, 7),
      commitDate: commitDate.trim(),
      commitMessage: commitMessage.trim(),
      branch: branch.trim(),
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Failed to get git info:', error);
    return NextResponse.json({
      commit: 'unknown',
      commitShort: 'unknown',
      commitDate: 'unknown',
      commitMessage: 'unknown',
      branch: 'unknown',
      timestamp: new Date().toISOString(),
    });
  }
} 