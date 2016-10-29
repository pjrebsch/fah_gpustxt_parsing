
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

  # @param location [String] location of raw GPUs.txt
  def initialize(location = GPUSTXT_URL, options = {})
    @location = location.to_s.freeze || GPUSTXT_URL
    set options
  end

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

    nil
  end

  def parse
    fetch

    raw_lines = @raw.split("\n")

    # Free up memory used by the raw string unless we were told
    # to keep it around.
    #
    # The string is garbage collected as long as no other references
    # to it (outside of this class) exist.
    @raw = nil unless @options[:cache_raw]

    @gpus = raw_lines.collect { |l| GPU.new(l) }.freeze

    nil
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
