import unittest

import dataprocessing.computation
from dataprocessing.entities import AdultEntities


class TestComputation(unittest.TestCase):
    dataset = [AdultEntities(1), AdultEntities(2)]

    def test_get_average(self):
        self.assertEqual(dataprocessing.computation.get_average("age", self.dataset), 1.5, "Average should be 1.5")

    def test_get_mean(self):
        self.assertEqual(dataprocessing.computation.get_mean("age", self.dataset), 1.5, "Mean should be 1.5")

    def test_get_value_distribution(self):
        self.assertEqual(dataprocessing.computation.get_value_distribution("age", self.dataset), {1: 1, 2: 1},
                         "Value distribution should be correct")


if __name__ == '__main__':
    unittest.main()
