import azure.functions as func
import json
from shared.pg_client import run_query

def main(req: func.HttpRequest) -> func.HttpResponse:
    emp_id = req.params.get('id')
    if not emp_id:
        return func.HttpResponse("Missing id", status_code=400)
    try:
        body = req.get_json()
    except ValueError:
        return func.HttpResponse("Invalid JSON", status_code=400)
    name = body.get('name')
    role = body.get('role')
    salary = body.get('salary')
    sql = "UPDATE employees SET name = COALESCE(%s, name), role = COALESCE(%s, role), salary = COALESCE(%s, salary) WHERE id = %s RETURNING *"
    data = run_query(sql, (name, role, salary, emp_id), fetch=True)
    return func.HttpResponse(json.dumps(data, default=str), mimetype='application/json')
