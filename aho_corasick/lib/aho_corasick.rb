require "aho_corasick/version"

module AhoCorasick
  class AhoCorasickTree
    attr_accessor :root

    def initialize(terms)
      @id = 0
      @root = AhoCorasickNode.new(@id)
      create_trie(terms)
      create_failure_links
    end

    def match(text)
      matches = Hash.new {|hash,key| hash[key] = []}
      current = @root
      text.each_char.with_index do |char, index|
        current = current.find(char)
        current.accepts.each do |term|
          matches[index - term.size + 1] << term
        end
      end
      matches
    end

    def to_s
      @root.to_s(0)
    end
    private

    def create_trie(terms)
      terms.each do |term|
        insert_term term
      end
    end

    def insert_term(term)
      node = @root
      term.each_char do |char|
        if node.has_link?(char)
          node = node.follow_link(char)
        else
          @id += 1
          node = node.create_link(@id, char)
        end
      end
      node.accepts << term
    end

    def create_failure_links
      queue = []
      @root.each do |char, node|
        node.failure = @root
        node.each do |c,n|
          queue << [c,n]
        end
      end
      while not queue.empty?
        char, node = queue.shift
        node.each do |c,n|
          queue << [c,n]
        end
        node.failure = node.parent.failure.find(char)
        node.accepts.concat node.failure.accepts
      end
    end
  end

  class AhoCorasickNode
    attr_reader :id, :accepts, :parent
    attr_accessor :failure

    def initialize(id, parent = nil)
      @id = id
      @parent = parent
      @links = {}
      @failure = nil
      @accepts = []
    end

    def has_link?(c)
      @links.has_key? c
    end

    def follow_link(c)
      @links[c]
    end

    def create_link(id, c)
      @links[c] = AhoCorasickNode.new(id, self)
    end

    def each(&block)
      @links.each &block
    end

    def find(c)
      if @links[c] 
        @links[c]
      else
        failure ? failure.find(c) : self
      end
    end

    def to_s(n)
      lines = []
      lines << "#{' ' * n}id:#{@id}, failure:#{failure ? failure.id : 'none'},  accepts:#{@accepts.join('|')}"
      @links.values.each do |child|
        lines << child.to_s(n+1)
      end
      lines.join("\n")
    end
  end
end
