
module FAHGPUstxtParsing
class GPU

  LINE_SECTION_DELIMITER = ':'.freeze

  # @return [Symbol]
  attr_reader :pci_vendor, :pci_device

  # A value of zero for either of these attributes means
  # that it is not supported.
  #
  # @return [Integer]
  attr_reader :gpu_type, :gpu_species

  # @return [String]
  attr_reader :description
  alias_method :name, :description

  # @param str [String]
  def initialize(str)
    sections = str.split(LINE_SECTION_DELIMITER)

    @pci_vendor  = sections[0].to_sym
    @pci_device  = sections[1].to_sym
    @gpu_type    = sections[2].to_i
    @gpu_species = sections[3].to_i
    @description = sections[4].strip.freeze
  end

  # @return [true, false]
  def whitelisted?
    @gpu_type + @gpu_species > 0
  end
  alias_method :supported?, :whitelisted?

  # @return [true, false]
  def blacklisted?
    !whitelisted?
  end

end
end
