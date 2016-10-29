
# Folding@Home GPUs.txt Parsing

This is a little Ruby library to parse [the Folding@Home GPUs.txt file](http://fah.stanford.edu/file-releases/public/GPUs.txt) into cute little GPU objects according to [the official GPUs.txt format specification](https://fah.stanford.edu/projects/FAHClient/wiki/FormatOfGPUsTxt).

## Example

Right here's your standard quick-n-dirty parse:

```
# Create new parser with default settings.
parser = FAHGPUstxtParsing::Parser.new

# You know what to do.
parser.parse

# Behold the fruits of your labor.
parser.gpus
```

## Options

### GPUs.txt location

If you don't specify a GPUs.txt location, it will retrieve the GPUs.txt file from Folding@Home's servers.

To specify a location, pass it as the first parameter when creating a parser:
```
FAHGPUstxtParsing::Parser.new('tmp/GPUs.txt')
```

If the location you provide is a valid file path, then it will read it from the local system, but if it isn't then it will assume that the location is a remote HTTP-accessible resource.

### Caching the raw file in memory

By default, the parser removes the internal reference to the original raw GPUs.txt string when calling `#parse` to allow it to be garbage-collected and free up some memory (assuming that your code isn't keeping a reference to it, too). If you still want access to the original raw string, you can override this behavior:
```
FAHGPUstxtParsing::Parser.new(cache_raw: true)
```
