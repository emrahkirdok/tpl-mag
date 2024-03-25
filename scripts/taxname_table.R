# Gerekli kütüphaneleri yükle
library(dplyr)
library(data.table)

# Dosya yollarını belirle
dosya_yolu <- "C:/Users/kursat/Desktop/table/pydamage_results/"
klasor_yolu <- "C:/Users/kursat/Desktop/table/pydamage_results/"

# Örnek klasörlerini belirle
ornek_klasorler <- c("tpl002", "tpl003", "tpl004", "tpl192", "tpl193", "tpl522", "tpl523", "tpl524", "tpl525")

# Boş bir liste oluştur
sonuc_tablolari <- list()

# Her örnek klasörü için işlem yap
for (klasor_adi in ornek_klasorler) {
  
  # Klasör içindeki dosya yolunu oluştur
  dosya_yolu_veri <- file.path(dosya_yolu, klasor_adi, "pydamage_filtered_results.csv")
  dosya_yolu_contig <- file.path(dosya_yolu, klasor_adi, "contig_coverage.txt")
  dosya_yolu_sequences <- file.path(dosya_yolu, klasor_adi, paste0(klasor_adi, ".sequences"))
  
  # Dosyalar varsa oku
  if (file.exists(dosya_yolu_veri) && file.exists(dosya_yolu_contig) && file.exists(dosya_yolu_sequences)) {
    
    # Dosyayı oku ve veri çerçevesine dönüştür
    veri <- fread(dosya_yolu_veri)
    
    # Antiklik değerini hesapla
    veri$Antiklik <- ifelse(veri$predicted_accuracy >= 0.95, TRUE, FALSE)
    
    # Örnek adı sütununu ekle
    veri$Sample <- klasor_adi
    
    # Contig verisini oku
    contig_veri <- fread(dosya_yolu_contig, header = FALSE)
    setnames(contig_veri, c("Contig", "Coverage_start", "Coverage_end", "Breadth_of_Coverage", "Length", "Coverage_percent", "Depth_of_Coverage", "GC_content", "TaxID"))
    
    # Sequences verisini oku ve sınıflandırma yap
    sequences_veri <- fread(dosya_yolu_sequences, header = FALSE)
    setnames(sequences_veri, c("Type", "Contig", "TaxID", "Length", "Classification"))
    sequences_veri$Classification <- ifelse(sequences_veri$Type == "C", "T", "F")
    
    # Sol birleşim yaparak verileri birleştir
    eslesme <- left_join(veri, contig_veri, by = c("reference" = "Contig"))
    eslesme <- left_join(eslesme, sequences_veri, by = c("reference" = "Contig"))
    
    # Classification ve TaxID sütunlarını kontrol et ve eksikse NA ekle
    if (!("Classification" %in% colnames(eslesme))) {
      eslesme$Classification <- NA
    }
    if (!("TaxID" %in% colnames(eslesme))) {
      eslesme$TaxID <- NA
    }
    
    # İstenen sütunları seç
    if ("Length" %in% colnames(eslesme)) {
      eslesme <- select(eslesme, reference, Antiklik, starts_with("CtoT"), Length, Breadth_of_Coverage, Depth_of_Coverage, TaxID, Classification)
    } else {
      eslesme <- select(eslesme, reference, Antiklik, starts_with("CtoT"), Breadth_of_Coverage, Depth_of_Coverage, TaxID, Classification)
    }
    
    # Sonuç tablosunu güncelle
    sonuc_tablolari[[klasor_adi]] <- eslesme
  }
}

# Tüm örneklerden oluşan birleşik bir veri çerçevesi oluştur
sonuc_tablosu <- bind_rows(sonuc_tablolari)

# Sonuçları göster
print(sonuc_tablosu)
