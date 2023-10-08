from dataprocessing.entities import AdultEntities
import numpy


def get_average(column_name, adult_entities_array: list[AdultEntities]):
    values = [getattr(column, column_name) for column in adult_entities_array]
    return numpy.average(values)


def get_mean(column_name, adult_entities_array: list[AdultEntities]):
    values = [getattr(column, column_name) for column in adult_entities_array]
    return numpy.mean(values)


def get_value_distribution(column_name, adult_entities_array: list[AdultEntities]):
    value_distribution_mapping = {}
    values = [getattr(column, column_name) for column in adult_entities_array]
    for value in values:
        if value_distribution_mapping.get(value, 0) == 0:
            value_distribution_mapping[value] = 1
        else:
            value_distribution_mapping[value] = 1 + value_distribution_mapping.get(value)
    return value_distribution_mapping
