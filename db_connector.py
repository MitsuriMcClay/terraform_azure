import psycopg2
import pandas as pd

database="postgresql-db" 
user='psqladmin@mcclaytest-pg-server' 
host='mcclaytest-pg-server.postgres.database.azure.com' 
password="1qazXSW@" 
port='5432' 
sslmode='require'

# PythonからPostgreSQLを操作する方法
conn = psycopg2.connect(database=database,
                        host=host,
                        user=user,
                        password=password,
                        port=port,
                        sslmode=sslmode)

# values = [['Guitar', 6, 'Blue Grass', 'Citole'],
#           ['Banjo', 5, 'Blue Grass', 'Bangie']]

# # Table名：Instrumentsを作成
# cursor = conn.cursor()
# sql = '''
#           CREATE TABLE Instruments (
#             id SERIAL,
#             instrument VARCHAR (255) NOT NULL,
#             strings INTEGER NOT NULL,
#             genre    VARCHAR (255) NOT NULL,
#             aliases  VARCHAR (255) NOT NULL,
#             PRIMARY KEY (id)
#           );
#           '''
# cursor.execute(sql)
# sql = "INSERT INTO Instruments (instrument, strings, genre, aliases) VALUES (%s, %s, %s, %s)"
# cursor.executemany(sql, values)
# conn.commit()


# データの追加
values = [['Ukulele', 4, 'Hawaiian', 'Small Guitar'],
           ['Bass', 6, 'Jazz', 'contrabass']]

cursor = conn.cursor()
sql = """ INSERT INTO Instruments (instrument, strings, genre, aliases) VALUES (%s, %s, %s, %s)"""
record_to_insert = values
cursor.executemany(sql, record_to_insert)

# # データ読み込み
sql = "SELECT * FROM Instruments"
#cursor.execute(sql)
#cursor.execute('SELECT * FROM category')
df = pd.read_sql(sql, conn)
#result = cursor.fetchall()
#print_results(result)
print(df)

# # 終了処理
# cursor.close()
# conn.close()


# 作成したテーブルを一覧表示する。
# cursor = conn.cursor()
# cursor.execute("""SELECT table_name FROM information_schema.tables
#        WHERE table_schema = 'public'""")
# for table in cursor.fetchall():
#     print(table)

# testtableを削除
# cursor = conn.cursor()
# sql = '''
#           DROP TABLE Instruments
#           '''
# cursor.execute(sql)
# conn.commit()


# Memo　テーブル作成例
# sql = '''
#           CREATE TABLE Instruments (
#             pageNo   integer Not Null ,
#             typeName VARCHAR (250),
#             count    INTEGER,
#             data     TEXT,
#             CONSTRAINT TestTable_pkey PRIMARY KEY (pageNo)
#           );
#           '''