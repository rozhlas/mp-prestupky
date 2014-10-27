require! {
  parse: "csv-parse"
  fs
  async
}
stream = fs.createReadStream "#__dirname/../data/praha_prest_6_13_5_14.csv"
reader = parse {delimiter: ','}
stream.pipe reader

minX = Infinity
maxX = -Infinity

minY = Infinity
maxY = -Infinity

out = {}
typIndices = {}
currentTypIndex = 0
reader.on \data (line) ->
  [..._,typ,x,y] = line
  return if x == 'x'
  x = parseFloat x .toFixed 5
  y = parseFloat y .toFixed 5
  return unless x and y
  typId = if typIndices[typ]
    that
  else
    currentTypIndex++
    i = currentTypIndex
    typIndices[typ] = i
    i
  id = [x, y, typId].join "\t"
  out[id] = out[id] + 1 || 1

<~ reader.on \end
output = for id, count of out
  id += "\t#count"
console.log "writing #{output.length} lines"
<~ fs.writeFile "#__dirname/../data/processed/grouped.tsv" output.join "\n"