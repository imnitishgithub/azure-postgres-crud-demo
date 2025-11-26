import azure.functions as func
from shared.pg_client import run_query

def main(req: func.HttpRequest) -> func.HttpResponse:
    emp_id = req.params.get('id')
    if not emp_id:
        return func.HttpResponse("Missing id", status_code=400)
    sql = "DELETE FROM employees WHERE id = %s RETURNING id"
    data = run_query(sql, (emp_id,), fetch=True)
    return func.HttpResponse(status_code=200, body=str(data))
