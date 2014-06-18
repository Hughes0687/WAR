module SQ

  class Queue

    attr_reader :start, :finish

    def initialize
      @start = nil
      @finish = nil
    end

    def peek
      return @start.value
    end
    
    def shift
      out = @start
      if @start.pointer != nil
        @start = @start.pointer
      else
        @start = @finish = Node.new
      end
      return out.value
    end
    
    def push(element)
      if @start == nil
        @start = @finish = Node.new(element, nil)
      else
        newNode = Node.new(element, nil)
        @finish.pointer = newNode
        @finish = newNode
      end
      return @finish.value
    end
  
  end

  class Node

    attr_accessor :value, :pointer

    def initialize(value = nil, pointer = nil)
      @value = value
      @pointer = pointer
    end

  end
  
end
