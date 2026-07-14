# Text-Analysis

This project performs sentiment analysis using comments from a newspaper vent line (Charleston 
Gazette-Mail)

The analysis begins by cleaning the raw text, which went in the order of
- Removing punctuation
- Removing numbers
- Removing website links
- Removing extra spaces
- Converting to lowercase

The cleaned text is analyzed using the NRC Emotion Lexicon from the syuzhet package.

Once the emotions and polarity were calculated, they were visualized using the ggplot package.

The emotion bar chart shows the frequency of each emotion in the text we analyzed, while the polarity bar chart shows the frequency of negative versus positive responses.

A comparison word cloud was generated to visualize the most frequently used words associated with each emotion
