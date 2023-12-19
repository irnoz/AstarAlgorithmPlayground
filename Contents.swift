//import UIKit
import Foundation

class Node {
    var parent: Node?
    var position: (Int, Int)
    var g: Int
    var h: Int
    var f: Int
    
    init(parent: Node?, position: (Int, Int)) {
        self.parent = parent
        self.position = position
        self.g = 0
        self.h = 0
        self.f = 0
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.position == rhs.position
    }
}

func astar(maze: [[Int]], start: (Int, Int), end: (Int, Int)) -> [(Int, Int)]? {
    // Create start and
    // end nodes
    let startNode = Node(parent: nil, position: start)
    startNode.g = 0
    startNode.h = 0
    startNode.f = 0
    
    let endNode = Node(parent: nil, position: end)
    endNode.g = 0
    endNode.h = 0
    endNode.f = 0
    
    // Open and cloased list
    // OPEN consists on nodes that have been visited but not expanded (meaning that sucessors have not been explored yet). This is the list of pending tasks.
    // CLOSE consists on nodes that have been visited and expanded (sucessors have been explored already and included in the open list, if this was the case).
    var openList = [Node]()
    var closedList = [Node]()
    
    // Add the start node
    // to the open list
    openList.append(startNode)
    
    while !openList.isEmpty {
        var currentNode = openList[0]
        var currentIndex = 0
        
        // Get the current node (node with the lowest f value)
        // Dequeue basically (not needed if queues are used)
        for (index, item) in openList.enumerated() {
            if item.f < currentNode.f {
                currentNode = item
                currentIndex = index
            }
        }
        
        // Remove the current node from the
        // open list and add to the closed list
        openList.remove(at: currentIndex)
        closedList.append(currentNode)
        
        if currentNode == endNode {
            var path = [(Int, Int)]()
            var current = currentNode
            
            // if target found
            // Reconstruct the path
            while current != nil {
                path.append(current.position)
                guard let parent = current.parent else {
                    break
                }
                current = parent
            }
            
            return path.reversed()
        }
        
        // Generate child nodes
        var children = [Node]()
        
        for newPosition in [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)] {
            let nodePosition = (currentNode.position.0 + newPosition.0, currentNode.position.1 + newPosition.1)
            
            // Check if the new
            // position is valid
            if nodePosition.0 > maze.count - 1 || nodePosition.0 < 0 || nodePosition.1 > maze[maze.count - 1].count - 1 || nodePosition.1 < 0 {
                continue
            }
            
            // Check it is
            // not bloackd
            if maze[nodePosition.0][nodePosition.1] != 0 {
                continue
            }
            
            // Create a new node
            // for the child
            let newNode = Node(parent: currentNode, position: nodePosition)
            children.append(newNode)
        }
        
        // Loop through children
        for child in children {
            for closedChild in closedList {
                // Skip if the child is
                // already in the closed list
                if child == closedChild {
                    continue
                }
            }
            
            // Calculate g, h, and f
            // values for the child
            child.g = currentNode.g + 1
            child.h = ((child.position.0 - endNode.position.0) ^^ 2) + ((child.position.1 - endNode.position.1) ^^ 2)
            child.f = child.g + child.h
            
            // Skip if the child is already
            // in the open list with a lower g value
            for openNode in openList {
                if child == openNode && child.g > openNode.g {
                    continue
                }
            }
            
            // Add the child
            // to the open list
            openList.append(child)
        }
    }
    
    return nil
}

func main() {
    let maze = [
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
    
    let start = (0, 0)
    let end = (7, 6)
    
    if let path = astar(maze: maze, start: start, end: end) {
        print(path)
    } else {
        print("No path found")
    }
}

main()


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}


