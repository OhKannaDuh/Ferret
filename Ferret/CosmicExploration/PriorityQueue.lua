---@class PriorityQueue : Object
PriorityQueue = Object:extend()

function PriorityQueue:new()
    self.heap = {}
end

function PriorityQueue:push(item, priority)
    table.insert(self.heap, { item = item, priority = priority })
    self:_sift_up(#self.heap)
end

function PriorityQueue:pop()
    local heap = self.heap
    if #heap == 0 then
        return nil
    end
    local top = heap[1].item
    heap[1] = heap[#heap]
    table.remove(heap)
    self:_sift_down(1)
    return top
end

function PriorityQueue:empty()
    return #self.heap == 0
end

function PriorityQueue:_sift_up(index)
    local heap = self.heap
    while index > 1 do
        local parent = math.floor(index / 2)
        if heap[parent].priority <= heap[index].priority then
            break
        end
        heap[parent], heap[index] = heap[index], heap[parent]
        index = parent
    end
end

function PriorityQueue:_sift_down(index)
    local heap = self.heap
    local size = #heap
    while true do
        local left = 2 * index
        local right = left + 1
        local smallest = index

        if left <= size and heap[left].priority < heap[smallest].priority then
            smallest = left
        end
        if right <= size and heap[right].priority < heap[smallest].priority then
            smallest = right
        end
        if smallest == index then
            break
        end

        heap[smallest], heap[index] = heap[index], heap[smallest]
        index = smallest
    end
end
