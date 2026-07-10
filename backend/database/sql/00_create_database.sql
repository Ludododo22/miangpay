SELECT 'CREATE DATABASE miangpay OWNER postgres ENCODING ''UTF8'''
WHERE NOT EXISTS (
  SELECT FROM pg_database WHERE datname = 'miangpay'
)\gexec
