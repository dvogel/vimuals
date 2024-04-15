require 'yaml'
require_relative '../vim_helpers'
require_relative '../text_helpers'

WIDTH = 80

def format_main(srcdoc)
  hyperlink = VimHyperlink::new("jq")
  toc_fmt = TableOfContentsPrinter::new(4, WIDTH)
  center = CenteringPrinter::new(WIDTH)
  section_indent = IndentPrinter::new(4, 0)

  format_prelude(center, srcdoc)

  srcdoc["sections"].each do |section|
    puts toc_fmt.format(section["title"], hyperlink.format_as_link(section["title"]))
  end

  srcdoc["sections"].each do |section|
    format_section(section_indent, section)
  end
end

def format_section(indent, section)
  hyperlink = VimHyperlink::new("jq")
  puts

  if section["title"]
    sec_prtr = SectionHeaderPrinter::new(indent.indent, WIDTH)
    link_text = hyperlink.format_as_anchor(section["title"])
    if link_text.length < WIDTH / 2
      puts sec_prtr.format(section["title"], link_text)
    else
      puts sec_prtr.format("", link_text)
      puts indent.format(section["title"])
    end
  end

  inner_indent = indent.increment

  if section["body"]
    section["body"].lines.each do |line|
      puts inner_indent.format(line)
    end
  end

  if section["entries"]
    section["entries"].each do |entry|
      format_section(inner_indent, entry)
    end
  end

  if section["examples"]
    section["examples"].each do |example|
      format_example(inner_indent, example)
    end
  end
end

def format_example(indent, example)
  puts indent.format(example["title"])
  inner = indent.increment
  puts inner.format(">")
  puts inner.format("program: #{example["program"]}")
  puts inner.format("input: #{example["input"]}")
  puts inner.format("output: #{example["output"]}")
  puts inner.format("<")
end

def format_prelude(center, srcdoc)
  puts "vimuals-jq.txt"
  puts
  puts center.format("JQ Manual")
  puts
  puts "Table of Contents"
  puts "-----------------"
  puts
end

def print_tree(indent, node_key, node)
  case node
  when Hash then
    puts indent.format("#{node_key}:")
    node.keys.each do |k|
      print_tree(indent.increment, k, node[k])
    end
  when Array then
    puts indent.format("#{node_key}:")
    node.each.with_index do |x, idx|
      print_tree(indent.increment, idx.to_s, x)
    end
  when String then puts indent.increment.format("#{node_key}: 'str'")
  else puts indent.format(node[k].to_s)
  end
end

srcdoc = YAML.load_file('sources/jq/manual.yml')
if ARGV.empty? || ARGV[0] == "format"
  format_main(srcdoc)
elsif ARGV[0] == "debug"
  print_tree(IndentPrinter::new(4, 0), "", srcdoc)
  binding.irb
end


