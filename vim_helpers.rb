
class VimHyperlink
  def initialize(prefix)
    @prefix = prefix
  end

  private def format_as_link_text(suffix)
    suffix
      .downcase
      .gsub(/[`\/\s\t]+/, '')
      .gsub(/[^a-z0-9\[\]?.<>=]+/, '-')
      .gsub(/[-]+$/, '')
  end

  def format_as_anchor(suffix)
    "*#{@prefix}-#{self.format_as_link_text(suffix)}*"
  end

  def format_as_link(suffix)
    "|#{@prefix}-#{self.format_as_link_text(suffix)}|"
  end
end
