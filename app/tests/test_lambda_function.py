import unittest
import sys
sys.path.append('app/src')
from lambda_process import lambda_handler
from unittest.mock import patch


class TestLambdaFunction(unittest.TestCase):

    def test_lambda_handler(self):
        # Define a sample event and context
        event = {}
        context = None

        # Patch the print function to capture the output
        with patch('builtins.print') as mock_print:
            # Invoke the lambda_handler function
            response = lambda_handler(event, context)

            # Assert that the print function was called with the expected message
            mock_print.assert_called_once_with("Hello, World!")

            # Assert the response returned by the lambda_handler function
            self.assertEqual(response['statusCode'], 200)
            self.assertEqual(response['body'], 'Hello, World!')


if __name__ == '__main__':
    unittest.main()
