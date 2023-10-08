from dataclasses import dataclass


@dataclass
class AdultEntities:
    age: int = 0
    workclass: str = ""
    fnlwgt: int = 0
    education: str = ""
    education_num: int = 0
    marital_status: str = ""
    occupation: str = ""
    relationship: str = ""
    race: str = ""
    sex: str = ""
    capital_gain: str = ""
    capital_loss: str = ""
    hours_per_week: str = ""
    native_country: str = ""
    income: str = ""
