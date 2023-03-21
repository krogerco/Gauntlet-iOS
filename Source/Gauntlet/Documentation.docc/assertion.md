# ``Gauntlet/Assertion``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

### Custom Operators

`Assertion` can be extended further to easily create new operators that suit your needs. See <doc:creating-custom-operators> for more detail.

## Topics

### Bool Operators
Operators on `Bool` values.
- ``Assertion/isTrue(line:)``
- ``Assertion/isFalse(line:)``

### Collection Operators
Operators for collections.
- ``Assertion/isEmpty(line:)``
- ``Assertion/isNotEmpty(line:)``
- ``Assertion/hasCount(_:line:)``

### Equality Operators
Operators for equality comparisons.
- ``Assertion/isEqualTo(_:line:)``
- ``Assertion/isEqualTo(_:accuracy:line:)``
- ``Assertion/isNotEqualTo(_:line:)``
- ``Assertion/isNotEqualTo(_:accuracy:line:)``

### Optional Operators
Operators for optional values.
- ``Assertion/isNotNil(line:)``
- ``Assertion/isNil(line:)``

### Result Operators
Operators on `Result` values.
- ``Assertion/isSuccess(line:)``
- ``Assertion/isFailure(line:)``

### Throwing Operators
Operators on expressions that can `throw`. There are variants of each function that handle `async` expressions.
- ``Assertion/throwsError(line:)-6unsp``
- ``Assertion/throwsError(line:)-5tpvw``
- ``Assertion/doesNotThrow(line:)-4m3y5``
- ``Assertion/doesNotThrow(line:)-7m2l5``

### Type Operators
Operators that validate the type conformance of a value.
- ``Assertion/isOfType(_:line:)``

### General Operators
Operators that work on any type.

- ``Assertion/then(line:_:)``

### Assertion Operators
Operators on Assertions. These are used when writing tests for a custom Assertion operator.

- ``Assertion/didPass(expectedName:expectedLine:line:)``
- ``Assertion/didFail(expectedName:expectedLine:line:)``

### Evaluate
The evaluate functions are called by operators to run validation logic and create a new Assertion. See <doc:creating-custom-operators> for more detail.

- ``Assertion/evaluate(name:lineNumber:evaluator:)``
- ``Assertion/asyncEvaluate(name:lineNumber:evaluator:)``
