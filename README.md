# Gren's official test framework

Write unit and fuzz tests for Gren code.

This package allows you to define tests, but in order to run them you will need a [test runner](https://github.com/gren-lang/test-runner-node).

This is a port of [elm-explorations/test](https://github.com/elm-explorations/test), it also contains a vendored port of [jinjor/elm-diff](https://github.com/jinjor/elm-diff).

## Quick Start

Here are three example tests:

```gren
suite : Test
suite =
    describe "The String module"
        [ describe "String.reverse" -- Nest as many descriptions as you like.
            [ test "has no effect on a palindrome" <|
                \_ ->
                    let
                        palindrome =
                            "hannah"
                    in
                        Expect.equal palindrome (String.reverse palindrome)

            -- Expect.equal is designed to be used in pipeline style, like this.
            , test "reverses a known string" <|
                \_ ->
                    "ABCDEFG"
                        |> String.reverse
                        |> Expect.equal "GFEDCBA"

            -- fuzz runs the test 100 times with randomly-generated inputs!
            , fuzz string "restores the original string if you run it again" <|
                \randomlyGeneratedString ->
                    randomlyGeneratedString
                        |> String.reverse
                        |> String.reverse
                        |> Expect.equal randomlyGeneratedString
            ]
        ]
```

This code uses a few common functions:

* `describe` to add a description string to a list of tests
* `test` to write a unit test
* `Expect` to determine if a test should pass or fail
* `fuzz` to run a function that produces a test several times with randomly-generated inputs

### Not running tests

During development, you'll often want to focus on specific tests, silence failing tests, or jot down many ideas for tests that you can't implement all at once. We've got you covered with `skip`, `only`, and `todo`:

```gren
wipSuite : Test
wipSuite =
    describe "skip, only, and todo"
        [ only <|
            describe "Marking this test as `only` means no other tests will be run!"
                [ test "This test will be run" <|
                    \_ -> 1 + 1 |> Expect.equal 2
                , skip <| test "This test will be skipped, even though it's in an `only`!" <|
                    \_ -> 2 + 3 |> Expect.equal 4
                ]
        , test "This test will be skipped because it has no `only`" <|
            \_ -> "left" |> Expect.equal "right"
        , todo "Make sure all splines are reticulated"
        ]
```

If you run this example, or any suite that uses one of these three functions, it will result in an _incomplete_ test run. No tests failed, but you also didn't run your entire suite, so we can't call it a success either. Incomplete test runs are reported to CI systems as indistinguishable from failed test runs, to safeguard against accidentally committing a gutted test suite!

