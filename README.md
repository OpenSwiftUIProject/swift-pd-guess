# swift-pd-guess

Try to guess the file name from private discriminator of a Swift symbol.

## Usgae

```shell
swift-pd-guess <hash> <words> --prefix <prefix> [--suffix <suffix>] [--max-count <max-count>]
```

## Example

For DemoKit binary, we can see some private symbol have `_00D91DAB7748ABA327DC94E69D678CAF` in their demangled name.

Eg. `_$s7DemoKit3FooV7Private33_00D91DAB7748ABA327DC94E69D678CAFLLVMn` --demangle--> `nominal type descriptor for DemoKit.Foo.(Private in _00D91DAB7748ABA327DC94E69D678CAF)`

We can then use `swift-pd-guess` to guess the file name using a given words array.

```shell
swift-pd-guess 00D91DAB7748ABA327DC94E69D678CAF Foo,Private,API,_,+, --prefix DemoKit
# Try brute force hash: 00D91DAB7748ABA327DC94E69D678CAF with dictionary ["Foo", "Private", "API", "_", "+"] max-4
# Found match: DemoKitFoo+Private.swift
```

The result is `DemoKit/Foo+Private.swift` since we are lucky to find a good words array.

## Related Projects

https://github.com/OpenSwiftUIProject/SwiftPrivateImportExample

## License

MIT. See LICENSE for detail.
