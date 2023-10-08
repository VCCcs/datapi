import requests as re
from dataprocessing import entities
import logging


def gather_dataset(path) -> list[entities.AdultEntities]:
    try:
        response = re.get(path)
        adult_entities_array = []
        for line in response.text.split("\n"):
            if len(line) > 0:
                data = line.split(",")
                try:
                    (adult_entities_array
                    ## a bit ugly, could be done by default through Pandas I guess, or a dedicated CSV library.
                    .append(entities
                         .AdultEntities(int(data[0]), data[1], int(data[2]), data[3], int(data[4]), data[5], data[6],
                                        data[7], data[8], data[9], data[10], data[11], data[12], data[13], data[14])))
            # Need to better handle the exception
                except:
                    logging.error(f"Error when processing the following line : {line}")
        return adult_entities_array

    except Exception as x:
        logging.error(x)
        # We could exit here.
