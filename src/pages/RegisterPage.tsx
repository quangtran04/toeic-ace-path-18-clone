import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { apiService } from "@/services/api";

const RegisterPage = () => {
  const navigate = useNavigate();
  const [hoTen, setHoTen] = useState("");
  const [email, setEmail] = useState("");
  const [matKhau, setMatKhau] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSuccess(null);
    if (!hoTen || !email || !matKhau) {
      setError("Vui lòng nhập đủ họ tên, email và mật khẩu");
      return;
    }
    try {
      setLoading(true);
      await apiService.authRegister({ hoTen, email, matKhau });
      setSuccess("Đăng ký thành công! Hãy đăng nhập.");
      setTimeout(()=> navigate("/login", { replace: true }), 800);
    } catch (err: any) {
      setError(err?.message || "Đăng ký thất bại");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Đăng ký</CardTitle>
          <CardDescription>Tạo tài khoản mới</CardDescription>
        </CardHeader>
        <form onSubmit={onSubmit}>
          <CardContent className="space-y-4">
            {error && <div className="text-sm text-destructive">{error}</div>}
            {success && <div className="text-sm text-green-600">{success}</div>}
            <div className="space-y-1">
              <label className="text-sm" htmlFor="hoten">Họ tên</label>
              <Input id="hoten" placeholder="Nguyễn Văn A" value={hoTen} onChange={e=>setHoTen(e.target.value)} />
            </div>
            <div className="space-y-1">
              <label className="text-sm" htmlFor="email">Email</label>
              <Input id="email" type="email" placeholder="you@example.com" value={email} onChange={e=>setEmail(e.target.value)} />
            </div>
            <div className="space-y-1">
              <label className="text-sm" htmlFor="password">Mật khẩu</label>
              <Input id="password" type="password" placeholder="••••••••" value={matKhau} onChange={e=>setMatKhau(e.target.value)} />
            </div>
          </CardContent>
          <CardFooter className="flex flex-col gap-3">
            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? "Đang đăng ký..." : "Đăng ký"}
            </Button>
            <div className="text-sm text-muted-foreground">
              Đã có tài khoản? <Link to="/login" className="underline">Đăng nhập</Link>
            </div>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
};

export default RegisterPage;
