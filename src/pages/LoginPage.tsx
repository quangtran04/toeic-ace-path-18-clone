import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { apiService } from "@/services/api";

const LoginPage = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!email || !password) {
      setError("Vui lòng nhập email và mật khẩu");
      return;
    }
    try {
      setLoading(true);
      await apiService.authLogin(email, password);
      navigate("/", { replace: true });
    } catch (err: any) {
      setError(err?.message || "Đăng nhập thất bại");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Đăng nhập</CardTitle>
          <CardDescription>Đăng nhập để tiếp tục học</CardDescription>
        </CardHeader>
        <form onSubmit={onSubmit}>
          <CardContent className="space-y-4">
            {error && <div className="text-sm text-destructive">{error}</div>}
            <div className="space-y-1">
              <label className="text-sm" htmlFor="email">Email</label>
              <Input id="email" type="email" placeholder="you@example.com" value={email} onChange={e=>setEmail(e.target.value)} />
            </div>
            <div className="space-y-1">
              <label className="text-sm" htmlFor="password">Mật khẩu</label>
              <Input id="password" type="password" placeholder="••••••••" value={password} onChange={e=>setPassword(e.target.value)} />
            </div>
          </CardContent>
          <CardFooter className="flex flex-col gap-3">
            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? "Đang đăng nhập..." : "Đăng nhập"}
            </Button>
            <div className="text-sm text-muted-foreground">
              Chưa có tài khoản? <Link to="/register" className="underline">Đăng ký</Link>
            </div>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
};

export default LoginPage;
