package ui

import (
	"fmt"

	"pira/dnsleak/internal/model"

	"github.com/fatih/color"
)

// Display handles colorful output to the terminal
type Display struct {
	titleColor   *color.Color
	ipColor      *color.Color
	dnsColor     *color.Color
	warningColor *color.Color
	successColor *color.Color
	errorColor   *color.Color
}

// NewDisplay creates a new Display instance with predefined colors
func NewDisplay() *Display {
	return &Display{
		titleColor:   color.New(color.FgHiBlue, color.Bold),
		ipColor:      color.New(color.FgHiCyan),
		dnsColor:     color.New(color.FgHiYellow),
		warningColor: color.New(color.FgHiRed),
		successColor: color.New(color.FgHiGreen),
		errorColor:   color.New(color.FgRed, color.Bold),
	}
}

// PrintTitle prints a title with color
func (d *Display) PrintTitle(title string) {
	d.titleColor.Println(title)
}

// PrintIPSection prints the IP section with formatting
func (d *Display) PrintIPSection(blocks []model.Block) {
	d.titleColor.Println("Your IP:")
	for _, block := range blocks {
		if block.Type == "ip" {
			if block.ASN != "" {
				d.ipColor.Printf("%s [%s, %s]\n", block.IP, block.CountryName, block.ASN)
			} else if block.CountryName != "" {
				d.ipColor.Printf("%s [%s]\n", block.IP, block.CountryName)
			} else {
				d.ipColor.Printf("%s\n", block.IP)
			}
		}
	}
	fmt.Println()
}

// PrintDNSSection prints the DNS section with formatting
func (d *Display) PrintDNSSection(blocks []model.Block) {
	dnsCount := 0
	for _, block := range blocks {
		if block.Type == "dns" {
			dnsCount++
		}
	}

	if dnsCount == 0 {
		d.warningColor.Println("No DNS servers found")
	} else {
		if dnsCount == 1 {
			d.titleColor.Printf("You use %d DNS server:\n", dnsCount)
		} else {
			d.titleColor.Printf("You use %d DNS servers:\n", dnsCount)
		}

		for _, block := range blocks {
			if block.Type == "dns" {
				if block.ASN != "" {
					d.dnsColor.Printf("%s [%s, %s]\n", block.IP, block.CountryName, block.ASN)
				} else if block.CountryName != "" {
					d.dnsColor.Printf("%s [%s]\n", block.IP, block.CountryName)
				} else {
					d.dnsColor.Printf("%s\n", block.IP)
				}
			}
		}
	}
	fmt.Println()
}

// PrintConclusionSection prints the conclusion section
func (d *Display) PrintConclusionSection(blocks []model.Block) {
	d.titleColor.Println("Conclusion:")
	for _, block := range blocks {
		if block.Type == "conclusion" {
			if block.IP != "" {
				// Check if DNS is leaking
				if block.IP == "DNS may be leaking." {
					d.warningColor.Println(block.IP)
				} else {
					d.successColor.Println(block.IP)
				}
			}
		}
	}
}

// PrintError prints an error message
func (d *Display) PrintError(err error) {
	d.errorColor.Printf("Error: %v\n", err)
}

// PrintSeparator prints a separator line
func (d *Display) PrintSeparator() {
	fmt.Println("---")
}
