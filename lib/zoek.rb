module Zoek
  # Simple document
  class Document
    attr_accessor :type, :designed_by, :name
    def initialize(obj)
      @type = obj["Type"]
      @designed_by = obj["Designed by"]
      @name = obj["Name"]
    end
  end

  class Index
    attr_accessor :index, :documents

    def initialize(db:)
      # Load json file
      raw = JSON.load(File.open(db, 'r'))
      @index = {}
      @documents = {}

      raw.each_with_index do |d, i|
        # index documents found in json-file
        index_and_memoize!(key: 'Name', object: d, id: i)
      end
    end

    def tokenize(string)
      return [] if !string
      # Seperate all words, also divided with spaces
      list = string.split(/\,|\s/).map(&:downcase)

      # split combinations of words into subsets
      other = string.split(",").map(&:downcase).map(&:strip)

      remaining = []
      # Add full names to index as well as seperated names:
      other.each do |obj|
        # Split combination words (like names) and add them all seperately in 
        # combination
        obj = obj.split(" ")
        while obj.size > 0 do
          remaining << obj.join(" ")
          obj.pop
        end
      end if other.is_a?(Array)

      # Return only unique 
      (list+remaining).flatten.uniq
    end

    # index and memoize documents in memory
    def index_and_memoize!(key:, object:, id:)

      object.keys.each do |key|
        tokenize(object[key]).each do |name|
          @index[name] = @index.fetch(name, Array.new) << id
        end
      end

      @documents[id] = Document.new(object)
    end
  end

  module Search

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def search(query)
        return [] if query.nil?
        terms, negatives = get_search_terms(query)

        ids = find_in_index(terms)|| []
        remove = find_in_index(negatives) || []

        return get_documents(ids) if remove.empty?
        get_documents(ids - remove)
      end

      def get_search_terms(query)
        # Split all words by space except for those in double quotes
        terms = query.strip.downcase
          .split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
          .reject(&:empty?)
          .map { |s| s.delete('"') }
          .uniq

        # Negative words start with - so filter those out
        negatives, positives = terms.partition { |term| term.starts_with?("-") }
        negatives = negatives.map { |s| s.delete('-') }

        [positives, negatives]
      end

      def find_in_index(words)
        results = []
        # Find the terms in the index
        words.each do |word|
          ids = Zoek::INDEX[word]
          results << ids if ids
        end

        # Reduce them by intersection of all arrays leaving only the documents
        # which have all the terms
        results.reduce(&:&)
      end

      # Retrieve documents from memory
      def get_documents(ids)
        results = []
        return results unless ids
        ids.uniq.each { |id| results << Zoek::DOCUMENTS.fetch(id) }
        results
      end
    end

  end
end
