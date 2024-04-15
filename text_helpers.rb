
class SpreadPrinter
  def initialize(indent, width, spread_char)
    @indent_text = " " * indent
    @width = width
    @spread_char = spread_char
  end

  def format(left, right)
    inner_len = @width - @indent_text.length - 2 - left.length - right.length
    inner_text = 
      if inner_len <= 0
        ""
      else
        @spread_char * inner_len
      end
    "#{@indent_text}#{left} #{inner_text} #{right}"
  end
end

class TableOfContentsPrinter
  def initialize(indent, width)
    @spread_printer = SpreadPrinter::new(indent, width, " ")
  end

  def format(name, dest)
    @spread_printer.format(name, dest)
  end
end

class SectionHeaderPrinter
  def initialize(indent, width)
    @spread_printer = SpreadPrinter::new(indent, width, " ")
  end

  def format(name, anchor)
    @spread_printer.format(name, anchor)
  end
end

class CenteringPrinter
  def initialize(width)
    @width = width
  end

  def format(text)
    indent_len = (@width - text.length) / 2
    indent_text = 
      if indent_len <= 0
        ""
      else
        " " * indent_len
      end
    "#{indent_text}#{text}"
  end
end

class IndentPrinter
  def initialize(incr, coeff)
    @incr = incr
    @coeff = coeff
    @indent_text = " " * (incr * coeff)
  end

  def indent
    @incr * @coeff
  end

  def increment
    return IndentPrinter::new(@incr, @coeff + 1)
  end

  def format(text)
    "#{@indent_text}#{text}"
  end
end

