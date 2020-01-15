package main

import (
	"encoding/json"
	"flag"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
)

var (
	baseDir = flag.String("base", "metadata", "Base of the metadata tree")
	outFile = flag.String("out", "metadata.json", "Output filename")
)

type pathnode struct {
	Content string               `json:"content,omitempty"`
	Entries map[string]*pathnode `json:"entries,omitempty"`
	Perm    string               `json:"perm,omitempty"`
}

func main() {
	flag.Parse()

	nodes := make(map[string]*pathnode)

	err := filepath.Walk(*baseDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			log.Printf("Could not add %s to archive: %v", path, err)
			return err
		}

		// The metadata module needs all the paths to be
		// relative to the base directory.  Once we have rpath
		// we write it into the struct and don't mess with it
		// anymore.
		rpath, err := filepath.Rel(*baseDir, path)
		if err != nil {
			log.Printf("Could not compute rpath for %s: %v", path, err)
			return nil
		}

		parent := filepath.Dir(rpath)
		base := filepath.Base(rpath)
		tmp := new(pathnode)
		if info.IsDir() {
			tmp.Entries = make(map[string]*pathnode)
			nodes[rpath] = tmp
		} else {
			log.Printf("Including %s in archive", rpath)
			b, err := ioutil.ReadFile(path)
			if err != nil {
				log.Printf("Could not add %s to archive: %v", rpath, err)
				return nil
			}
			tmp.Content = string(b[:])
		}

		// If the parent isn't the base, i.e. this isn't the
		// root node, then add this node to the list of
		// entries that this node maintains.
		if parent != base {
			nodes[parent].Entries[base] = tmp
		}

		return nil
	})
	if err != nil {
		log.Printf("error walking the path %q: %v\n", *baseDir, err)
		return
	}

	out, err := json.Marshal(nodes["."].Entries)
	if err != nil {
		log.Println("Error marshaling archive:", err)
		os.Exit(1)
	}

	if err := ioutil.WriteFile(*outFile, out, 0644); err != nil {
		log.Println("Error writing archive:", err)
		os.Exit(2)
	}

	log.Println(string(out[:]))
}
