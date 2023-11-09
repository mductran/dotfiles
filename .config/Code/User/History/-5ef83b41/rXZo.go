package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	levenshtein "github.com/ka-weihe/fast-levenshtein"
)

type Node struct {
	word     string
	Children map[int]*Node
}

type BKTree struct {
	root             *Node
	DistanceFunction func(string, string) int
}

func InitTree() *BKTree {
	return &BKTree{
		root:             nil,
		DistanceFunction: levenshtein.Distance,
	}
}

func (tree *BKTree) AddNode(s string) {
	if tree.root == nil {
		tree.root = &Node{word: s, Children: make(map[int]*Node)}
		return
	}

	current := tree.root
	for {
		distance := tree.DistanceFunction(s, current.word)
		if target, ok := current.Children[distance]; ok {
			current = target
		} else {
			current.Children[distance] = &Node{word: s, Children: make(map[int]*Node)}
			break
		}
	}
}

func (tree *BKTree) Search(key string, maxDistance int) []*Node {
	var results []*Node

	if tree.root == nil {
		return results
	}

	var candidates []*Node
	candidates = append(candidates, tree.root)
	for len(candidates) > 0 {
		candidate := candidates[0]
		candidates = candidates[1:]

		distance := tree.DistanceFunction(key, candidate.word)
		if distance < maxDistance {
			results = append(results, candidate)
		}

		low := distance - maxDistance
		high := distance + maxDistance

		for remainingDistance, node := range candidate.Children {
			if remainingDistance >= low && remainingDistance <= high {
				candidates = append(candidates, node)
			}
		}
	}

	return results
}

func GetLine(filename string, names chan string, readErr chan error) {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		names <- scanner.Text()
	}
	close(names)
	readErr <- scanner.Err()
}

func ReadFile(filename string) <-chan string {
	names := make(chan string)
	readErr := make(chan error)

	go GetLine(filename, names, readErr)

	for name := range names {
		fmt.Println(name)
	}

	if err := <-readErr; err != nil {
		log.Fatal(err)
	}

	return names
}

func testTree() {
	bktree := InitTree()

	bktree.AddNode("some")
	bktree.AddNode("soft")
	bktree.AddNode("same")
	bktree.AddNode("mole")
	bktree.AddNode("soda")
	bktree.AddNode("salmon")

	b, err := json.MarshalIndent(bktree.root, "", " ")
	if err != nil {
		panic(err)
	}
	fmt.Println(b)

	r := bktree.Search("sort", 2)
	for _, node := range r {
		fmt.Println(node.word)
	}
}

func main() {

	start := time.Now()

	ReadFile("hash")

	elapse := time.Since(start)
	fmt.Println(elapse)
}
