import azure.functions as func
import json
from shared.pg_client import run_query

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        body = req.get_json()
    except ValueError:
        return func.HttpResponse("Invalid JSON", status_code=400)
    name = body.get('name')
    role = body.get('role')
    salary = body.get('salary')
    if not name:
        return func.HttpResponse("Missing name", status_code=400)
    sql = "INSERT INTO employees (name, role, salary) VALUES (%s, %s, %s) RETURNING id"
    result = run_query(sql, (name, role, salary), fetch=True)
    return func.HttpResponse(json.dumps(result), status_code=201, mimetype='application/json')
