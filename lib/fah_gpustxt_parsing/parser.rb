
require 'httparty'

module FAHGPUstxtParsing
class Parser

  DEFAULT_OPTIONS = {
    cache_raw: false
  }.freeze

  GPUSTXT_URL = 'http://fah.stanford.edu/file-releases/public/GPUs.txt'.freeze

  # @return [String]
  attr_reader :location, :raw

  # @return [Array<FAHGPUstxtParsing::GPU>]
  attr_reader :gpus

  # @param [String] optional; location of raw GPUs.txt
  # @param [Hash] optional; options
  def initialize(*args)
    options = {}

    args[0...2].each do |a|
      if a.is_a? Hash
        options = a
      else
        @location = args[0].to_s.freeze
      end
    end

    @location ||= GPUSTXT_URL
    set options
  end

  # Retrieves GPUs.txt as a string from the location
  # specified for the parser.
  #
  # This method is idempotent.
  #
  # @return [String]
  def fetch
    @raw ||= (
      if File.exist?(@location)
        File.open(@location).read
      else
        response = HTTParty.get(@location)

        if response.code == 200
          response.body
        else
          ''
        end
      end
    ).freeze
  end

  # @return [Array<FAHGPUstxtParsing::GPU>]
  def parse
    fetch

    raw_lines = @raw.split("\n")

    # Free up memory used by the raw string unless we were told
    # to keep it around.
    #
    # The string is garbage collected as long as no other references
    # to it (outside of this class) exist.
    @raw = nil unless @options[:cache_raw]

    @gpus = Array.new
    while l = raw_lines.shift
      @gpus << GPU.new(l)
    end
    @gpus.freeze
  end

  protected

  # @param options [Hash]
  def set(options)
    valid_options = DEFAULT_OPTIONS.keys
    relevant_options = options.select do |k,v|
      valid_options.include? k
    end

    @options = DEFAULT_OPTIONS.merge(relevant_options).freeze

    nil
  end

end
end
