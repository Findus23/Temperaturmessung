#!/bin/bash
cut -d ',' -f '2-' dygraph.csv > vorbereitet.csv
cut -d ',' -f '1' dygraph.csv > datum.csv
