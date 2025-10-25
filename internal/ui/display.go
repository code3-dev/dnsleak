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
func (d *Display) PrintIPSection(networkInfos []model.NetworkInfo) {
	d.titleColor.Println("Your IP:")
	for _, networkInfo := range networkInfos {
		if networkInfo.Type == "ip" {
			if networkInfo.ASN != "" {
				d.ipColor.Printf("%s [%s, %s]\n", networkInfo.IP, networkInfo.CountryName, networkInfo.ASN)
			} else if networkInfo.CountryName != "" {
				d.ipColor.Printf("%s [%s]\n", networkInfo.IP, networkInfo.CountryName)
			} else {
				d.ipColor.Printf("%s\n", networkInfo.IP)
			}
		}
	}
	fmt.Println()
}

// PrintDNSSection prints the DNS section with formatting
func (d *Display) PrintDNSSection(networkInfos []model.NetworkInfo) {
	dnsCount := 0
	for _, networkInfo := range networkInfos {
		if networkInfo.Type == "dns" {
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

		for _, networkInfo := range networkInfos {
			if networkInfo.Type == "dns" {
				if networkInfo.ASN != "" {
					d.dnsColor.Printf("%s [%s, %s]\n", networkInfo.IP, networkInfo.CountryName, networkInfo.ASN)
				} else if networkInfo.CountryName != "" {
					d.dnsColor.Printf("%s [%s]\n", networkInfo.IP, networkInfo.CountryName)
				} else {
					d.dnsColor.Printf("%s\n", networkInfo.IP)
				}
			}
		}
	}
	fmt.Println()
}

// PrintConclusionSection prints the conclusion section
func (d *Display) PrintConclusionSection(networkInfos []model.NetworkInfo) {
	d.titleColor.Println("Conclusion:")
	for _, networkInfo := range networkInfos {
		if networkInfo.Type == "conclusion" {
			if networkInfo.IP != "" {
				// Check if DNS is leaking
				if networkInfo.IP == "DNS may be leaking." {
					d.warningColor.Println(networkInfo.IP)
				} else {
					d.successColor.Println(networkInfo.IP)
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
