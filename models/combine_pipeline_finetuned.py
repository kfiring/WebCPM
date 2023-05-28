import torch
import os


# model1 = torch.load("model_part1.pt")
# model2 = torch.load("model_part2.pt")
# model3 = torch.load("model_part3.pt")
# model4 = torch.load("model_part4.pt")
# model5 = torch.load("model_part5.pt")
# model_combine = {**model1, **model2, **model3, **model4, **model5}
# torch.save(model_combine, "cpm_10b_webcpm_pipeline_finetuned.pt")

if __name__ == "__main__":
    model_files = ["model_part1.pt", "model_part2.pt", "model_part3.pt", 
                   "model_part4.pt", "model_part5.pt"]
    
    final_model_file = "cpm_10b_webcpm_pipeline_finetuned.pt"
    tmp_model_file = "tmp.pt"
    model_combined = None
    for mf in model_files:
        model = torch.load(mf)
        print(f"loaded {mf}")
        if model_combined is None:
            model_combined = model
            continue
        tmp_combined = {**model_combined, **model}
        torch.save(tmp_combined, tmp_model_file)
        print(f"merged {mf} into {tmp_model_file}")
        del model
        del model_combined
        model_combined = torch.load(tmp_model_file)
    os.rename(tmp_model_file, final_model_file)
