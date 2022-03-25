import hug
import datetime
from influxdb_client import InfluxDBClient

token = token
org = org
bucket = bucket

@hug.get("/",output=hug.output_format.html)
def index():
    with open('index.html') as myfile:
        html=myfile.read()
    return html

@hug.get("/tomato")
def values(type:hug.types.text,agestart:hug.types.text,agestop:hug.types.text):
    s=""
    with InfluxDBClient(url="http://127.0.0.1:8086", token=token, org=org) as client:
        if type == "all":
            query = 'from(bucket: "a") \
                        |> range(start: '+agestart+' , stop: '+agestop+') \
                        |> filter(fn: (r) => r["_measurement"] == "MisuraPrsTemHum") \
                        |> filter(fn: (r) => r["_field"] == "hum" or r["_field"] == "tem" or r["_field"] == "prs") \
                        |> filter(fn: (r) => r["device"] == "ESP32") \
                        |> aggregateWindow(every: 10s, fn: mean, createEmpty: false) \
                        |> yield(name: "_result")'
        else:
            query = 'from(bucket: "a") \
                        |> range(start: '+agestart+' , stop: '+agestop+') \
                        |> filter(fn: (r) => r["_measurement"] == "MisuraPrsTemHum") \
                        |> filter(fn: (r) => r["_field"] == "'+type+'") \
                        |> filter(fn: (r) => r["device"] == "ESP32") \
                        |> aggregateWindow(every: 10s, fn: mean, createEmpty: false) \
                        |> yield(name: "_result")'
        try:
            tables = client.query_api().query(query, org=org)
        except:
           return s 
        for table in tables:
            for record in table.records:
                s+=record["_field"]+","+str(record["_value"])+","+str(record["_time"])+",  <br>  "
        return s
    
