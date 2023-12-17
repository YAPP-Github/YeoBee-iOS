import datetime

def get_current_date():
    today = datetime.date.today() # Format the date as "YYYY/MM/DD"
    formatted_date = today.strftime('%Y/%m/%d')
    return formatted_date

print(get_current_date())
