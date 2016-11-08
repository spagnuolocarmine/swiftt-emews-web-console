import io;
import sys;
import files;

string emews_root = getenv("EMEWS_PROJECT_ROOT");

app (file out, file err) repast (file shfile, string param_line, string outputdir)
{
    "bash" shfile param_line outputdir emews_root @stdout=out @stderr=err;
}

app (void o) make_dir(string dirname) {
  "mkdir" "-p" dirname;
}

app (void o) cp_message_center() {
  "cp" (strcat(emews_root,"/complete_model/MessageCenter.log4j.properties")) ".";
}

cp_message_center() => {
  file repast_sh = input(emews_root+"/scripts/repast.sh");
  file upf = input(argv("f"));
  string upf_lines[] = file_lines(upf);
  foreach s,i in upf_lines {
    string instance = "instance_%i/" % (i+1);
    make_dir(instance) => {
      file out <instance+"out.txt">;
      file err <instance+"err.txt">;
      (out,err) = repast(repast_sh, s, instance);
    }
  }
}
