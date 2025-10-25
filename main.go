package main

import (
	"pira/dnsleak/internal/api"
	"pira/dnsleak/internal/ui"
)

func main() {
	// Create API client and UI display
	client := api.NewClient()
	display := ui.NewDisplay()

	// Display title
	display.PrintTitle("DNS Leak Test")
	display.PrintSeparator()

	// Get test ID
	testID, err := client.GetTestID()
	if err != nil {
		display.PrintError(err)
		return
	}

	// Perform fake pings
	display.PrintTitle("Testing DNS leak...")
	client.PerformFakePings(testID)

	// Get results
	results, err := client.GetResults(testID)
	if err != nil {
		display.PrintError(err)
		return
	}

	// Display results
	display.PrintIPSection(results)
	display.PrintDNSSection(results)
	display.PrintConclusionSection(results)
}
