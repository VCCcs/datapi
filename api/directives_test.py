import unittest
import directives

class TestDirectives(unittest.TestCase):

    def test_is_supported_column(self):
        self.assertEqual(directives.is_supported_column("yolo"), False, "Should return False for an unsupported column")

    def test_is_numerical_column(self):
        self.assertEqual(directives.is_numerical_column("education"), False, "Should return False if a column is not numerical")

if __name__ == '__main__':
    unittest.main()