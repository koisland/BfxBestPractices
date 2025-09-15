
def test_files_eq():
    with open("5_testing/data/a.txt") as fh:
        # Read the file line-by-line, check if line is non-empty, and remove any newline characters.
        a = [line.strip() for line in fh if line]
    with open("5_testing/data/b.txt") as fh:
        # Read the file line-by-line, check if line is non-empty, and remove any newline characters.
        b = [line.strip() for line in fh if line]
    
    assert a == b, f"a ({a}) and b ({b}) not equal"
