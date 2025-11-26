import azure.functions as func
import json
from shared.pg_client import run_query

def main(req: func.HttpRequest) -> func.HttpResponse:
    emp_id = req.params.get('id')
    if emp_id:
        sql = "SELECT * FROM employees WHERE id = %s"
        data = run_query(sql, (emp_id,), fetch=True)
    else:
        sql = "SELECT * FROM employees ORDER BY id"
        data = run_query(sql, None, fetch=True)
    return func.HttpResponse(json.dumps(data, default=str), mimetype='application/json')
