# Testing
Testing is an important process in bioinformatics method development.

It allows you to understand the invariants (rules) of your program.
* ex. This block of code should always returns this data type.
* ex. At this point in my program, this object/variable should have this state.

__It is as important as having controls in wet-lab experiments.__

In Python, this is very easy with `pytest`.
```python
def test_something():
    a = 1
    b = 1
    assert a == b, "a does not equal b"
```

To run it:
```bash
pytest -v 5_testing/scripts/test_basic.py
```

Running an end-to-end testing the output of a program is called an integration test. This is something I often do with command-line programs.
```
test/data/
├── input.txt
└── output.txt
```

```python
def work(input_data):
    # Some function that performs some operation on input data and returns some output 
    ...
    return output

def test_integration():
    # read test/data/input.txt
    input_data = ...
    # read test/data/output.txt
    expected_output_data = ...
    assert work(input_data) == expected_output_data, "Something is wrong with my program or it is non-deterministic"
```

# Demonstration: Fixing a broken test
Read the output of this command and fix the failing test.
```bash
pytest -v 5_testing/scripts/test_files.py
```
