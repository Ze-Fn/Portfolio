import pdfplumber

def extract_text_from_pdf(pdf_path, output_txt_path):
    try:
        # Open the PDF file
        with pdfplumber.open(pdf_path) as pdf:
            extracted_text = ""
            
            # Iterate through each page
            for i, page in enumerate(pdf.pages):
                # Extract text from the current page
                page_text = page.extract_text()
                
                if page_text:
                    extracted_text += f"--- Page {i + 1} ---\n"
                    extracted_text += page_text + "\n\n"
            
            # Save the result to a text file
            with open(output_txt_path, "w", encoding="utf-8") as f:
                f.write(extracted_text)
                
        print(f"Success! Text extracted to: {output_txt_path}")

    except Exception as e:
        print(f"An error occurred: {e}")

# Usage
pdf_file = "C:/Users/blast/OneDrive/Documents/__Learning/Portfolio/Data/Hasil CPNS 2024 Kemendikbud/HasilCPNS2024KemendikbudLampiran1.pdf"  # Replace with your file path
output_file = "extracted_text.txt"

extract_text_from_pdf(pdf_file, output_file)