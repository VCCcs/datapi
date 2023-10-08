from dataprocessing.entities import AdultEntities


# Should be into some configuration or settings files.
adult_entities_numerical_column = ["age", "fnlwgt", "education_num"]
adult_entities_supported_column = [f for f in dir(AdultEntities) if
                                   not callable(getattr(AdultEntities, f)) and not f.startswith('__')]


def is_supported_column(column_name):
    return column_name in adult_entities_supported_column


def is_numerical_column(column_name):
    return column_name in adult_entities_numerical_column
