from datetime import timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.dummy import DummyOperator
from airflow.utils.dates import days_ago
args = {
    'owner': 'airflow',
}

with DAG(
    dag_id='ingest-transform-class7',
    default_args=args,
    schedule_interval='0 0 * * *',
    start_date=days_ago(2),
    dagrun_timeout=timedelta(minutes=60),
    tags=['ingest', 'transform'],
    params={"example_key": "example_value"},
) as dag:

    finaliza_proceso = DummyOperator(
        task_id='finaliza_proceso',
    )

    comienza_proceso = DummyOperator(
        task_id='comienza_proceso',
    )
    ingest = BashOperator(
        task_id='ingest',
        bash_command='/usr/bin/sh /home/hadoop/scripts/ingest_c7.sh ',
    )


    transform = BashOperator(
        task_id='transform',
        bash_command='ssh hadoop@172.17.0.2 /home/hadoop/spark/bin/spark-submit --files /home/hadoop/hive/conf/hive-site.xml /home/hadoop/scripts/ex_5_class7.py ',
    )


    comienza_proceso >>ingest >> transform >>finaliza_proceso




if __name__ == "__main__":
    dag.cli()

