"""Run recovered SQL with its CSV import step in a disposable database."""
from pathlib import Path
import csv
import sqlite3

ROOT = Path(__file__).resolve().parent

def build_database():
    connection = sqlite3.connect(':memory:')
    sql = (ROOT / 'analysis.sql').read_text(encoding='utf-8')
    # CSV loading originally happened in a GUI between table creation and analysis.
    # Preserve that ordering; running the original script alone queries empty tables.
    marker = '/* Part 4.2:'
    schema, separator, analysis = sql.partition(marker)
    if not separator:
        raise ValueError('Cannot locate the analysis section')
    connection.executescript(schema)
    for table, columns in [('movies', 3), ('ratings', 4)]:
        with (ROOT / 'data' / (table + '.csv')).open(newline='', encoding='utf-8-sig') as file:
            reader = csv.reader(file)
            next(reader)  # Source CSVs have one header row.
            connection.executemany('INSERT INTO ' + table + ' VALUES (' + ','.join('?' * columns) + ')', reader)
    connection.executescript(marker + analysis)
    return connection

def main():
    connection = build_database()
    try:
        for table in ['movies', 'ratings', 's3_users_count', 's4_popular_movies', 's5_highest_stars', 's6_converted_date', 's7_good_oldies', 's8_frequent_critics', 's9_movies']:
            print(table, connection.execute('SELECT COUNT(*) FROM ' + table).fetchone()[0])
        print('\nMost-reviewed movies:')
        for title, count in connection.execute('SELECT title, num_of_reviews FROM s4_popular_movies ORDER BY num_of_reviews DESC LIMIT 10'):
            print(f'{count:>6}  {title}')
    finally:
        connection.close()

if __name__ == '__main__':
    main()
