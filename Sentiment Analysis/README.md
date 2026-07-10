# Text-Analysis

This folder contains my sentiment analysis using comments from a newspaper vent line (Charleston 
Gazette-Mail)

It starts out with taking raw text and cleaning it, which went in the order of
-Removing punctuation
-Removing numbers
-Removing website links
-Removing extra spaces
-Converting to lowercase

The next step was to identify emotion in the text using the NRC emotion lexicon from the syuzhet package.

Once the emotions and polarity were calculated, they were visualized using the ggplot package.

The emotion bar chart shows the frequency of each emotion in the text we analyzed, while the polarity bar chart shows the frequency of negative versus positive responses.

A word cloud was also plotted to visualize what words were being used the most in the newspaper. 
